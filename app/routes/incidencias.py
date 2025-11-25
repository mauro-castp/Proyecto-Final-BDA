from flask import Blueprint, jsonify, render_template, request, session
from utils.decorators import login_required, role_required

incidencias_bp = Blueprint('incidencias', __name__)

def init_incidencias_routes(app, mysql):
    
    # Ruta para la página de incidencias
    incidencias_bp = Blueprint('incidencias', __name__)
    @login_required
    def incidencias_page():
        return render_template('incidencias.html')

    # ✅ FALTA ESTA RUTA - AGREGARLA
    @incidencias_bp.route('/api/incidencias', methods=['GET'])
    @login_required
    def obtener_incidencias():
        """Obtener incidencias con filtros y paginación"""
        try:
            estado = request.args.get('estado', '')
            tipo = request.args.get('tipo', '')
            impacto = request.args.get('impacto', '')
            pagina = int(request.args.get('pagina', 1))
            limite = int(request.args.get('limite', 10))
            
            offset = (pagina - 1) * limite
            
            cur = mysql.connection.cursor()
            cur.callproc('incidenciasListar', [estado, tipo, impacto, offset, limite])
            
            # Primer resultado: lista de incidencias
            incidencias = cur.fetchall()
            
            # Avanzar al siguiente resultado
            if cur.nextset():
                # Segundo resultado: información de paginación
                paginacion = cur.fetchone()
            else:
                paginacion = {}
            
            cur.close()
            
            return jsonify({
                'incidencias': incidencias,
                'paginacion': paginacion
            })
        except Exception as e:
            print(f"Error en obtener_incidencias: {str(e)}")
            return jsonify({'error': str(e)}), 500

    @incidencias_bp.route('/api/incidencias/<int:id>', methods=['GET'])
    @login_required
    def obtener_incidencia(id):
        """Obtener una incidencia por ID"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('incidenciaObtenerPorId', [id])
            incidencia = cur.fetchone()
            cur.close()
            
            if not incidencia:
                return jsonify({'error': 'Incidencia no encontrada'}), 404
                
            return jsonify(incidencia)
        except Exception as e:
            print(f"Error en obtener_incidencia: {str(e)}")
            return jsonify({'error': str(e)}), 500

    @incidencias_bp.route('/api/incidencias', methods=['POST'])
    @login_required
    @role_required([1, 2, 3])
    def crear_incidencia():
        """Crear nueva incidencia"""
        cur = None
        try:
            data = request.get_json()
            user_id = session.get('user_id', 1)
            
            # Validar campos requeridos
            campos_requeridos = ['id_zona', 'id_tipo_incidencia', 'descripcion', 'fecha_inicio', 'id_nivel_impacto']
            for campo in campos_requeridos:
                if campo not in data or data[campo] is None:
                    return jsonify({'error': f'El campo {campo} es requerido'}), 400
            
            # Validar formato de fecha_inicio
            if not data['fecha_inicio'] or data['fecha_inicio'] == 'null:00':
                return jsonify({'error': 'La fecha de inicio es requerida y debe tener un formato válido'}), 400
            
            # Manejar fecha_fin - si es 'null:00' o vacío, convertir a None
            fecha_fin = data.get('fecha_fin')
            if fecha_fin in ['null:00', '', None]:
                fecha_fin = None
            
            print(f"📦 Datos para crear incidencia:")
            print(f"  - id_zona: {data['id_zona']}")
            print(f"  - id_tipo_incidencia: {data['id_tipo_incidencia']}")
            print(f"  - fecha_inicio: {data['fecha_inicio']}")
            print(f"  - fecha_fin: {fecha_fin}")
            print(f"  - id_nivel_impacto: {data['id_nivel_impacto']}")
            
            cur = mysql.connection.cursor()
            
            cur.callproc('incidenciaRegistrar', [
                data['id_zona'],
                data['id_tipo_incidencia'],
                data['descripcion'],
                data['fecha_inicio'],
                fecha_fin,
                data['id_nivel_impacto'],
                user_id,
                data.get('observaciones', '')
            ])
            
            result = cur.fetchone()
            
            # Consumir cualquier resultado adicional
            while cur.nextset():
                pass
            
            mysql.connection.commit()
            
            return jsonify({
                'message': 'Incidencia registrada correctamente', 
                'id': result['id_incidencia']
            })
        except Exception as e:
            print(f"Error en crear_incidencia: {str(e)}")
            if cur:
                try:
                    while cur.nextset():
                        pass
                    mysql.connection.rollback()
                except:
                    pass
            return jsonify({'error': str(e)}), 500
        finally:
            if cur:
                cur.close()

    @incidencias_bp.route('/api/incidencias/<int:id>', methods=['PUT'])
    @login_required
    @role_required([1, 2, 3])
    def actualizar_incidencia(id):
        """Actualizar estado de incidencia usando procedimiento almacenado"""
        cur = None
        try:
            print(f"📝 Actualizando incidencia ID: {id}")
            data = request.get_json()
            print(f"📦 Datos recibidos: {data}")
            
            # VALIDACIÓN ROBUSTA
            if not data:
                return jsonify({'error': 'No se recibieron datos'}), 400
                
            if 'id_estado_incidencia' not in data:
                return jsonify({'error': 'El campo id_estado_incidencia es requerido'}), 400
            
            estado_incidencia = data['id_estado_incidencia']
            
            # Validar que no sea None
            if estado_incidencia is None:
                return jsonify({'error': 'id_estado_incidencia no puede ser nulo'}), 400
                
            # Validar que sea un número válido
            try:
                estado_incidencia = int(estado_incidencia)
                if estado_incidencia not in [1, 2, 3]:
                    return jsonify({'error': 'El estado debe ser 1 (Activa), 2 (Monitoreo) o 3 (Resuelta)'}), 400
            except (ValueError, TypeError):
                return jsonify({'error': 'id_estado_incidencia debe ser un número válido'}), 400
            
            # Obtener comentario (requerido)
            comentario = data.get('comentario', '')
            if not comentario or comentario.strip() == '':
                return jsonify({'error': 'El comentario de actualización es requerido'}), 400
            
            # Manejar fecha_fin (opcional)
            fecha_fin = data.get('fecha_fin')
            
            cur = mysql.connection.cursor()
            
            # Llamar al procedimiento almacenado
            print(f"🔧 Llamando procedimiento incidenciaActualizar con: {id}, {estado_incidencia}, {fecha_fin}, {comentario}")
            
            cur.callproc('incidenciaActualizar', [
                id,
                estado_incidencia,
                fecha_fin,
                comentario
            ])
            
            # ✅ CONSUMIR TODOS LOS RESULTADOS
            result = cur.fetchone()
            
            # Consumir cualquier resultado adicional
            while cur.nextset():
                pass
            
            mysql.connection.commit()
            
            print(f"✅ Incidencia {id} actualizada: {result}")
            return jsonify({'message': result['mensaje'] if result else 'Incidencia actualizada correctamente'})
            
        except Exception as e:
            print(f"❌ Error en actualizar_incidencia: {str(e)}")
            if cur:
                try:
                    # Consumir cualquier resultado pendiente antes del rollback
                    while cur.nextset():
                        pass
                    mysql.connection.rollback()
                except:
                    pass
            return jsonify({'error': f'Error interno del servidor: {str(e)}'}), 500
        finally:
            # ✅ SIEMPRE CERRAR EL CURSOR
            if cur:
                try:
                    cur.close()
                except:
                    pass

    @incidencias_bp.route('/api/incidencias/<int:id>', methods=['DELETE'])
    @login_required
    @role_required([1, 2])
    def eliminar_incidencia(id):
        """Eliminar incidencia"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('incidenciaEliminar', [id])
            result = cur.fetchone()
            
            # Consumir todos los resultados
            while cur.nextset():
                pass
            
            mysql.connection.commit()
            cur.close()
            
            return jsonify({'message': result['mensaje']})
        except Exception as e:
            print(f"Error en eliminar_incidencia: {str(e)}")
            mysql.connection.rollback()
            return jsonify({'error': str(e)}), 500

    @incidencias_bp.route('/api/incidencias/estadisticas', methods=['GET'])
    @login_required
    def obtener_estadisticas():
        """Obtener estadísticas de incidencias"""
        try:
            cur = mysql.connection.cursor()
            # Usar procedimiento para estadísticas
            cur.callproc('incidenciasEstadisticas')
            estadisticas = cur.fetchone()
            cur.close()
            
            return jsonify({
                'total': estadisticas['total'],
                'activas': estadisticas['activas'],
                'altas': estadisticas['altas'],
                'promedio_resolucion': float(estadisticas['promedio_resolucion']) if estadisticas['promedio_resolucion'] else 0
            })
        except Exception as e:
            print(f"Error en obtener_estadisticas: {str(e)}")
            # Si el procedimiento no existe, devolver valores por defecto
            return jsonify({
                'total': 0,
                'activas': 0,
                'altas': 0,
                'promedio_resolucion': 0
            })

    @incidencias_bp.route('/api/zonas', methods=['GET'])
    @login_required
    def obtener_zonas():
        """Obtener catálogo de zonas"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('zonasActivasListar')
            zonas = cur.fetchall()
            cur.close()
            return jsonify(zonas)
        except Exception as e:
            print(f"Error en obtener_zonas: {str(e)}")
            return jsonify({'error': str(e)}), 500

    return incidencias_bp