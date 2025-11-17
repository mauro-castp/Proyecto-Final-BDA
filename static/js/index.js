// Cargar estadísticas al iniciar
async function cargarEstadisticas() {
    try {
        const data = await apiCall('/api/dashboard/estadisticas');

        document.getElementById('pedidosCount').textContent = data.pedidos_pendientes || 0;
        document.getElementById('entregasCount').textContent = data.entregas_pendientes || 0;
        document.getElementById('rutasCount').textContent = data.rutas_activas || 0;
        document.getElementById('incidenciasCount').textContent = data.incidencias_activas || 0;
    } catch (error) {
        console.error('Error cargando estadísticas:', error);
    }
}

// Cargar estadísticas cuando la página esté lista
document.addEventListener('DOMContentLoaded', cargarEstadisticas);