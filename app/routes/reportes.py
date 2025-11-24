# routes/reportes.py
from flask import Blueprint, jsonify, request
from flask_mysqldb import MySQL
from utils.decorators import login_required, role_required
from datetime import datetime

reportes_bp = Blueprint('reportes', __name__)

def init_reportes_routes(app, mysql):
    @reportes_bp.route('/api/reportes/otp')
    @login_required
    @role_required([1, 4, 2])
    def reporte_otp():
        """Reporte OTP por rango de fechas"""
        try:
            desde = request.args.get('desde')
            hasta = request.args.get('hasta')
            cur = mysql.connection.cursor()
            cur.callproc('otpRango', [desde, hasta])
            data = cur.fetchall()
            cur.close()
            return jsonify(data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @reportes_bp.route('/api/reportes/costos-km')
    @login_required
    @role_required([1, 4, 2])
    def reporte_costos_km():
        """Reporte de costos por KM"""
        try:
            desde = request.args.get('desde')
            hasta = request.args.get('hasta')
            cur = mysql.connection.cursor()
            cur.callproc('costosKMRango', [desde, hasta])
            data = cur.fetchall()
            cur.close()
            return jsonify(data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @reportes_bp.route('/api/reportes/productividad')
    @login_required
    @role_required([1, 4, 2])
    def reporte_productividad():
        """Reporte de productividad por repartidor"""
        try:
            desde = request.args.get('desde')
            hasta = request.args.get('hasta')
            cur = mysql.connection.cursor()
            cur.callproc('productividadRepartidor', [desde, hasta])
            data = cur.fetchall()
            cur.close()
            return jsonify(data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @reportes_bp.route('/api/reportes/entregas-zona')
    @login_required
    @role_required([1, 4, 2])
    def reporte_entregas_zona():
        """Reporte de entregas por zona"""
        try:
            desde = request.args.get('desde')
            hasta = request.args.get('hasta')
            cur = mysql.connection.cursor()
            cur.callproc('entregasZona', [desde, hasta])
            data = cur.fetchall()
            cur.close()
            return jsonify(data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @reportes_bp.route('/api/reportes/kpi-mes')
    @login_required
    @role_required([1, 4, 2])
    def reporte_kpi_mes():
        """Reporte KPI global por mes"""
        try:
            anio = request.args.get('anio', datetime.now().year)
            mes = request.args.get('mes', datetime.now().month)
            cur = mysql.connection.cursor()
            cur.callproc('kpiGlobalMes', [anio, mes])
            data = cur.fetchall()
            cur.close()
            return jsonify(data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    @reportes_bp.route('/api/reportes/auditoria-entregas')
    @login_required
    @role_required([1, 4])
    def reporte_auditoria_entregas():
        """Reporte de auditoría de entregas"""
        try:
            desde = request.args.get('desde')
            hasta = request.args.get('hasta')
            cur = mysql.connection.cursor()
            cur.callproc('auditoriaEntrega', [desde, hasta])
            data = cur.fetchall()
            cur.close()
            return jsonify(data)
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return reportes_bp