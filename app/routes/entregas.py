# routes/entregas.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

entregas_bp = Blueprint('entregas', __name__)

def init_entregas_routes(app, mysql):
    @entregas_bp.route('/api/entregas', methods=['GET'])
    @login_required
    def obtener_entregas():
        """Obtener todas las entregas - PROCEDIMIENTOS"""
        try:
            cur = mysql.connection.cursor()
            
            if session['user_role'] == 3:  # Repartidor
                cur.callproc('entregasObtenerPorRepartidor', [session['user_id']])
            else:
                cur.callproc('entregasObtenerTodas')
                
            entregas = cur.fetchall()
            cur.close()
            return jsonify(entregas)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas/<int:id>', methods=['GET'])
    @login_required
    def obtener_entrega(id):
        """Obtener entrega por ID - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('entregaObtenerPorId', [id])
            entrega = cur.fetchone()
            cur.close()
            
            if not entrega:
                return jsonify({'error': 'Entrega no encontrada'}), 404
                
            return jsonify(entrega)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def asignar_entrega():
        """Asignar entrega - PROCEDIMIENTO EXISTENTE"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('entregaAsignar', [
                data['id_pedido'],
                data.get('id_ruta'),
                data['id_vehiculo'],
                data['id_repartidor']
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'capacidad_insuficiente':
                return jsonify({'error': 'Capacidad del vehículo insuficiente'}), 400
            else:
                return jsonify({'message': 'Entrega asignada', 'id': result['status']})
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas/<int:id>/confirmar', methods=['POST'])
    @login_required
    @role_required([1, 2, 3])
    def confirmar_entrega(id):
        """Confirmar entrega - PROCEDIMIENTO EXISTENTE"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('entregaConfirmar', [
                id,
                data['hora_real'],
                data.get('evidencia_url', '')
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'estado_invalido':
                return jsonify({'error': 'Estado de entrega inválido'}), 400
            else:
                return jsonify({'message': 'Entrega confirmada'})
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @entregas_bp.route('/api/entregas/<int:id>/reintento', methods=['POST'])
    @login_required
    @role_required([1, 2, 3])
    def reintentar_entrega(id):
        """Registrar reintento de entrega - PROCEDIMIENTO EXISTENTE"""
        try:
            data = request.get_json()
            cur = mysql.connection.cursor()
            
            cur.callproc('entregaReintento', [
                id,
                data['motivo_fallo']
            ])
            result = cur.fetchone()
            mysql.connection.commit()
            cur.close()
            
            if result['status'] == 'limite_reintentos':
                return jsonify({'error': 'Límite de reintentos alcanzado'}), 400
            else:
                return jsonify({'message': 'Reintento registrado'})
                
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return entregas_bp