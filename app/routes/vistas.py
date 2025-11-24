# routes/vistas.py
from flask import Blueprint, jsonify
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

vistas_bp = Blueprint('vistas', __name__)

def init_vistas_routes(app, mysql):
    @vistas_bp.route('/api/vistas/entregas-hoy')
    @login_required
    def obtener_entregas_hoy():
        """Obtener entregas planificadas para hoy - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vEntregasHoy")
            entregas = cur.fetchall()
            cur.close()
            return jsonify(entregas)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/otp-ruta-mes')
    @login_required
    @role_required([1, 4, 2])
    def obtener_otp_ruta_mes():
        """Obtener OTP por ruta del mes actual - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vOtpPorRutaMes")
            otp_data = cur.fetchall()
            cur.close()
            return jsonify(otp_data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/costos-km')
    @login_required
    @role_required([1, 4, 2])
    def obtener_costos_km():
        """Obtener costos por KM por vehículo - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vCostosPorKM")
            costos = cur.fetchall()
            cur.close()
            return jsonify(costos)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/entregas-zona')
    @login_required
    def obtener_entregas_zona():
        """Obtener entregas por zona - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vEntregasPorZona")
            entregas_zona = cur.fetchall()
            cur.close()
            return jsonify(entregas_zona)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/incidencias-activas')
    @login_required
    def obtener_incidencias_activas():
        """Obtener incidencias activas - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vIncidenciasActivas")
            incidencias = cur.fetchall()
            cur.close()
            return jsonify(incidencias)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/tiempo-promedio-entrega')
    @login_required
    @role_required([1, 4, 2])
    def obtener_tiempo_promedio_entrega():
        """Obtener tiempo promedio de entrega - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vTiempoPromedioEntrega")
            tiempo_promedio = cur.fetchone()
            cur.close()
            return jsonify(tiempo_promedio)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/productividad-repartidores')
    @login_required
    @role_required([1, 4, 2])
    def obtener_productividad_repartidores():
        """Obtener productividad de repartidores - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vProductividadRepartidor")
            productividad = cur.fetchall()
            cur.close()
            return jsonify(productividad)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/pedidos-por-estado')
    @login_required
    def obtener_pedidos_por_estado():
        """Obtener pedidos por estado - VISTA"""
        try:
            cur = mysql.connection.cursor()
            cur.execute("SELECT * FROM vPedidosPorEstado")
            pedidos_estado = cur.fetchall()
            cur.close()
            return jsonify(pedidos_estado)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return vistas_bp