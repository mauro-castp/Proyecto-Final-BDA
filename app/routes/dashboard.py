# routes/dashboard.py
from flask import Blueprint, jsonify, session
from flask_mysqldb import MySQL
from utils.decorators import login_required

dashboard_bp = Blueprint('dashboard', __name__)

def init_dashboard_routes(app, mysql):
    @dashboard_bp.route('/api/dashboard/estadisticas')
    @login_required
    def obtener_estadisticas_dashboard():
        """Obtener estadísticas para el dashboard"""
        try:
            cur = mysql.connection.cursor()
            
            # Estadísticas básicas
            cur.execute("""
                SELECT 
                    (SELECT COUNT(*) FROM pedidos WHERE id_estado_pedido IN (1,2)) as pedidos_pendientes,
                    (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega IN (1,2)) as entregas_pendientes,
                    (SELECT COUNT(*) FROM rutas WHERE id_estado_ruta = 1) as rutas_activas,
                    (SELECT COUNT(*) FROM incidencias WHERE id_estado_incidencia = 1) as incidencias_activas,
                    (SELECT ROUND(
                        (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega = 3) * 100.0 / 
                        NULLIF((SELECT COUNT(*) FROM entregas), 0), 2
                    )) as tasa_exito
            """)
            stats = cur.fetchone()
            
            # Datos de vistas para dashboard
            cur.execute("SELECT * FROM vPedidosPorEstado")
            pedidos_por_estado = cur.fetchall()
            
            cur.execute("SELECT * FROM vEntregasHoy")
            entregas_hoy = cur.fetchall()
            
            cur.execute("SELECT * FROM vIncidenciasActivas")
            incidencias_activas = cur.fetchall()
            
            cur.execute("SELECT * FROM vEntregasPorZona")
            entregas_zona = cur.fetchall()
            
            cur.execute("SELECT * FROM vTiempoPromedioEntrega")
            tiempo_promedio_entrega = cur.fetchone()
            
            cur.close()
            
            return jsonify({
                'estadisticas': stats,
                'pedidos_por_estado': pedidos_por_estado,
                'entregas_hoy': entregas_hoy,
                'incidencias_activas': incidencias_activas,
                'entregas_zona': entregas_zona,
                'tiempo_promedio_entrega': tiempo_promedio_entrega
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return dashboard_bp