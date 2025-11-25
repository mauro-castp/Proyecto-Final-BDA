# routes/rutas.py
from flask import Blueprint, jsonify, request, session
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required
import json

rutas_bp = Blueprint('rutas', __name__)

def init_rutas_routes(app, mysql):

    @rutas_bp.route('/api/rutas', methods=['GET'])
    @login_required
    def obtener_rutas():
        """Obtener rutas con filtros y paginación"""
        cur = None
        try:
            estado = request.args.get('estado', '')
            zona = request.args.get('zona', '')
            fecha_param = request.args.get('fecha', '')
            pagina = int(request.args.get('pagina', 1))
            limite = int(request.args.get('limite', 10))
            
            print(f"🔍 Parámetros recibidos - estado: {estado}, zona: {zona}, fecha: {fecha_param}")
            
            offset = (pagina - 1) * limite
            
            cur = mysql.connection.cursor()
            cur.callproc('rutasListar', [estado, zona, fecha_param, offset, limite])
            
            # Primer resultado: lista de rutas
            rutas = cur.fetchall()
            print(f"📦 Rutas obtenidas de BD: {len(rutas)} registros")
            
            if rutas:
                print("📋 Ejemplo de primera ruta:", dict(rutas[0]))
            
            # Avanzar al siguiente resultado
            paginacion = {}
            if cur.nextset():
                paginacion_data = cur.fetchone()
                if paginacion_data:
                    paginacion = dict(paginacion_data)
            
            # Consumir cualquier resultado adicional
            while cur.nextset():
                pass
            
            # Convertir a diccionario
            rutas_dict = []
            for ruta in rutas:
                rutas_dict.append(dict(ruta))
            
            return jsonify({
                'rutas': rutas_dict,
                'paginacion': paginacion
            })
        except Exception as e:
            print(f"❌ Error en obtener_rutas: {str(e)}")
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()

    @rutas_bp.route('/api/rutas/<int:id>', methods=['GET'])
    @login_required
    def obtener_ruta(id):
        """Obtener ruta por ID con sus paradas"""
        cur = None
        try:
            cur = mysql.connection.cursor()
            cur.callproc('rutaObtenerPorId', [id])
            
            # Primer resultado: información de la ruta
            ruta = cur.fetchone()
            
            if not ruta:
                return jsonify({'error': 'Ruta no encontrada'}), 404
            
            # Segundo resultado: paradas de la ruta
            paradas = []
            if cur.nextset():
                paradas = cur.fetchall()
            
            # Consumir cualquier resultado adicional
            while cur.nextset():
                pass
            
            # Combinar resultados
            ruta_completa = dict(ruta)
            ruta_completa['paradas'] = paradas
            
            return jsonify(ruta_completa)
        except Exception as e:
            print(f"Error en obtener_ruta: {str(e)}")
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()

    @rutas_bp.route('/api/rutas', methods=['POST'])
    @login_required
    @role_required([1, 2])  # Admin y Planificador
    def crear_ruta():
        """Crear nueva ruta - pedidos son opcionales"""
        cur = None
        try:
            data = request.get_json()
            user_id = session.get('user_id', 1)
            
            print(f"📥 Datos recibidos para crear ruta: {data}")
            
            # Validar campos requeridos (pedidos ahora es opcional)
            campos_requeridos = ['nombre_ruta', 'id_zona', 'fecha', 'id_repartidor', 'id_vehiculo']
            for campo in campos_requeridos:
                if campo not in data or not data[campo]:
                    return jsonify({'error': f'El campo {campo} es requerido'}), 400
            
            # Pedidos es opcional, si no viene, usar lista vacía
            pedidos = data.get('pedidos', [])
            
            cur = mysql.connection.cursor()
            
            # Llamar al procedimiento para crear ruta
            cur.callproc('rutaCrear', [
                data['nombre_ruta'],
                data['id_zona'],
                data['fecha'],
                data['id_vehiculo'],
                data['id_repartidor'],
                json.dumps(pedidos)  # Secuencia de pedidos como JSON (puede estar vacío)
            ])
            
            # Obtener el resultado del procedimiento
            result = cur.fetchone()
            
            # Consumir todos los resultados pendientes para evitar "Commands out of sync"
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            
            print(f"✅ Ruta creada con ID: {result['id_ruta']}")
            
            return jsonify({
                'message': 'Ruta creada correctamente', 
                'id': result['id_ruta']
            })
            
        except Exception as e:
            print(f"❌ Error en crear_ruta: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': f'Error al crear la ruta: {str(e)}'}), 500
        finally:
            if cur:
                cur.close()

    @rutas_bp.route('/api/rutas/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2])
    def actualizar_ruta(id):
        """Actualizar ruta existente"""
        cur = None
        try:
            print(f"🔧 Actualizando ruta {id}")
            data = request.get_json()
            print(f"📥 Datos recibidos: {data}")
            
            cur = mysql.connection.cursor()
            cur.callproc('rutaActualizar', [
                id,
                data.get('nombre_ruta'),
                data.get('id_estado_ruta'),
                data.get('id_repartidor'),
                data.get('id_vehiculo')
            ])
            
            # Consumir todos los resultados del procedimiento
            result = cur.fetchone()
            
            # Avanzar a través de cualquier resultado adicional
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            
            print(f"✅ Ruta {id} actualizada: {result['mensaje']}")
            return jsonify({'message': result['mensaje'] if result else 'Ruta actualizada correctamente'})
            
        except Exception as e:
            print(f"❌ Error en actualizar_ruta {id}: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()
    
    @rutas_bp.route('/api/rutas/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1, 2])
    def eliminar_ruta(id):
        """Eliminar una ruta"""
        cur = None
        try:
            cur = mysql.connection.cursor()
            cur.callproc('rutaEliminar', [id])
            
            result = cur.fetchone()
            
            # Consumir todos los resultados pendientes
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            
            return jsonify({'message': result['mensaje']})
            
        except Exception as e:
            print(f"Error en eliminar_ruta: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()


    @rutas_bp.route('/api/rutas/<int:id>/iniciar', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def iniciar_ruta(id):
        """Iniciar una ruta (cambiar estado a activa)"""
        cur = None
        try:
            cur = mysql.connection.cursor()
            cur.callproc('rutaIniciar', [id])
            
            result = cur.fetchone()
            
            # Consumir todos los resultados pendientes
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            
            return jsonify({'message': result['mensaje']})
        except Exception as e:
            print(f"Error en iniciar_ruta: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()

    @rutas_bp.route('/api/rutas/<int:id>/completar', methods=['POST'])
    @login_required
    @role_required([1, 2])
    def completar_ruta(id):
        """Completar una ruta (cambiar estado a completada)"""
        cur = None
        try:
            cur = mysql.connection.cursor()
            cur.callproc('rutaCompletar', [id])
            
            result = cur.fetchone()
            
            # Consumir todos los resultados pendientes
            while cur.nextset():
                pass
                
            mysql.connection.commit()
            
            return jsonify({'message': result['mensaje']})
        except Exception as e:
            print(f"Error en completar_ruta: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()

    return rutas_bp