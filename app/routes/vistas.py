# routes/vistas.py
from flask import Blueprint, jsonify
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required

vistas_bp = Blueprint('vistas', __name__)

def init_vistas_routes(app, mysql):
    @vistas_bp.route('/api/vistas/entregas-hoy')
    @login_required
    def obtener_entregas_hoy():
        """Obtener entregas planificadas para hoy - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('dashboardEntregasHoy')
            entregas = cur.fetchall()
            cur.close()
            return jsonify(entregas)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/otp-ruta-mes')
    @login_required
    @role_required([1, 4, 2])
    def obtener_otp_ruta_mes():
        """Obtener OTP por ruta del mes actual - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('vistaOtpPorRutaMes')
            otp_data = cur.fetchall()
            cur.close()
            return jsonify(otp_data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/costos-km')
    @login_required
    @role_required([1, 4, 2])
    def obtener_costos_km():
        """Obtener costos por KM por vehículo - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('vistaCostosPorKM')
            costos = cur.fetchall()
            cur.close()
            return jsonify(costos)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/entregas-zona')
    @login_required
    def obtener_entregas_zona():
        """Obtener entregas por zona - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('dashboardEntregasPorZona')
            entregas_zona = cur.fetchall()
            cur.close()
            return jsonify(entregas_zona)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/incidencias-activas')
    @login_required
    def obtener_incidencias_activas():
        """Obtener incidencias activas - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('dashboardIncidenciasActivas')
            incidencias = cur.fetchall()
            cur.close()
            return jsonify(incidencias)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/tiempo-promedio-entrega')
    @login_required
    @role_required([1, 4, 2])
    def obtener_tiempo_promedio_entrega():
        """Obtener tiempo promedio de entrega - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('dashboardTiempoPromedioEntrega')
            tiempo_promedio = cur.fetchone()
            cur.close()
            return jsonify(tiempo_promedio)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/productividad-repartidores')
    @login_required
    @role_required([1, 4, 2])
    def obtener_productividad_repartidores():
        """Obtener productividad de repartidores - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('vistaProductividadRepartidores')
            productividad = cur.fetchall()
            cur.close()
            return jsonify(productividad)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @vistas_bp.route('/api/vistas/pedidos-por-estado')
    @login_required
    def obtener_pedidos_por_estado():
        """Obtener pedidos por estado - PROCEDIMIENTO"""
        try:
            cur = mysql.connection.cursor()
            cur.callproc('dashboardPedidosPorEstado')
            pedidos_estado = cur.fetchall()
            cur.close()
            return jsonify(pedidos_estado)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return vistas_bp