// Función auxiliar para llamadas API
async function apiCall(url, options = {}) {
    try {
        const response = await fetch(url, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        });

        if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
        }

        return await response.json();
    } catch (error) {
        console.error('Error en API call:', error);
        throw error;
    }
}

// Cargar estadísticas del dashboard
async function cargarEstadisticas() {
    try {
        mostrarLoading(true);

        const data = await apiCall('/api/dashboard/estadisticas');
        console.log('Datos del dashboard:', data);

        // Ocultar loading y mostrar stats
        mostrarLoading(false);

        // Actualizar contadores
        if (data.estadisticas) {
            actualizarContadores(data.estadisticas);
        } else {
            actualizarContadores(data);
        }

    } catch (error) {
        console.error('Error cargando estadísticas:', error);
        mostrarLoading(false);
        mostrarError('No se pudieron cargar las estadísticas del dashboard');
    }
}

// Actualizar los contadores en la UI
function actualizarContadores(stats) {
    document.getElementById('pedidosCount').textContent = stats.pedidos_pendientes || 0;
    document.getElementById('entregasCount').textContent = stats.entregas_pendientes || 0;
    document.getElementById('rutasCount').textContent = stats.rutas_activas || 0;
    document.getElementById('incidenciasCount').textContent = stats.incidencias_activas || 0;

    // Animación de contadores
    animarContadores();
}

// Mostrar/ocultar loading
function mostrarLoading(mostrar) {
    const loadingSpinner = document.getElementById('loadingSpinner');
    const statsGrid = document.getElementById('statsGrid');

    if (mostrar) {
        loadingSpinner.style.display = 'block';
        statsGrid.style.display = 'none';
    } else {
        loadingSpinner.style.display = 'none';
        statsGrid.style.display = 'grid';
    }
}

// Animación para los contadores
function animarContadores() {
    const counters = document.querySelectorAll('.stat-card h3');

    counters.forEach(counter => {
        const target = parseInt(counter.textContent);
        let current = 0;
        const increment = target / 50;

        if (target === 0) return;

        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                counter.textContent = target;
                clearInterval(timer);
            } else {
                counter.textContent = Math.floor(current);
            }
        }, 30);
    });
}

// Cargar entregas de hoy
async function cargarEntregasHoy() {
    try {
        const entregas = await apiCall('/api/vistas/entregas-hoy');
        mostrarEntregasHoy(entregas);
    } catch (error) {
        console.error('Error cargando entregas de hoy:', error);
        document.getElementById('entregasHoyList').innerHTML =
            '<div class="text-danger">Error cargando entregas</div>';
    }
}

// Mostrar lista de entregas de hoy
function mostrarEntregasHoy(entregas) {
    const container = document.getElementById('entregasHoyList');

    if (!entregas || entregas.length === 0) {
        container.innerHTML = '<div class="text-muted">No hay entregas programadas para hoy</div>';
        return;
    }

    const html = entregas.slice(0, 5).map(entrega => `
        <div class="d-flex justify-content-between align-items-center mb-2 p-2 border-bottom">
            <div>
                <strong>${entrega.Nombre_Cliente}</strong>
                <br>
                <small class="text-muted">${entrega.Direccion_Entrega}</small>
            </div>
            <span class="badge bg-${getBadgeColor(entrega.Estado_Entrega)}">
                ${entrega.Estado_Entrega}
            </span>
        </div>
    `).join('');

    container.innerHTML = html;

    if (entregas.length > 5) {
        container.innerHTML += `
            <div class="text-center mt-2">
                <small class="text-muted">+${entregas.length - 5} más entregas</small>
            </div>
        `;
    }
}

// Cargar incidencias activas
async function cargarIncidenciasActivas() {
    try {
        const incidencias = await apiCall('/api/vistas/incidencias-activas');
        mostrarIncidenciasActivas(incidencias);
    } catch (error) {
        console.error('Error cargando incidencias activas:', error);
        document.getElementById('incidenciasActivasList').innerHTML =
            '<div class="text-danger">Error cargando incidencias</div>';
    }
}

// Mostrar lista de incidencias activas
function mostrarIncidenciasActivas(incidencias) {
    const container = document.getElementById('incidenciasActivasList');

    if (!incidencias || incidencias.length === 0) {
        container.innerHTML = '<div class="text-success">✅ No hay incidencias activas</div>';
        return;
    }

    const html = incidencias.slice(0, 5).map(incidencia => `
        <div class="mb-2 p-2 border-bottom">
            <div class="d-flex justify-content-between align-items-start">
                <strong class="text-warning">${incidencia.Tipo_Incidencia}</strong>
                <span class="badge bg-${getImpactoColor(incidencia.Impacto)}">
                    ${incidencia.Impacto}
                </span>
            </div>
            <small class="text-muted">${incidencia.Zona_Afectada}</small>
            <br>
            <small>${incidencia.descripcion || 'Sin descripción'}</small>
        </div>
    `).join('');

    container.innerHTML = html;
}

// Helper para colores de badges
function getBadgeColor(estado) {
    const colores = {
        'pendiente': 'warning',
        'asignada': 'info',
        'en camino': 'primary',
        'entregada': 'success',
        'fallida': 'danger'
    };
    return colores[estado.toLowerCase()] || 'secondary';
}

function getImpactoColor(impacto) {
    const colores = {
        'bajo': 'success',
        'medio': 'warning',
        'alto': 'danger',
        'crítico': 'dark'
    };
    return colores[impacto.toLowerCase()] || 'secondary';
}

// Mostrar error al usuario
function mostrarError(mensaje) {
    // Crear alerta de Bootstrap
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-danger alert-dismissible fade show';
    alertDiv.innerHTML = `
        <strong>Error:</strong> ${mensaje}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    // Insertar al inicio del contenido
    const welcomeSection = document.querySelector('.welcome-section');
    welcomeSection.insertBefore(alertDiv, welcomeSection.firstChild);

    // Auto-remover después de 5 segundos
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function () {
    console.log('Inicializando dashboard LUM...');

    // Cargar todos los datos
    cargarEstadisticas();
    cargarEntregasHoy();
    cargarIncidenciasActivas();

    // Actualizar cada 2 minutos
    setInterval(cargarEstadisticas, 120000);
});