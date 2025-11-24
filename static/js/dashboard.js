class Dashboard {
    constructor() {
        this.currentPeriod = 'mes';
        this.charts = {};
        this.isManualRefresh = false;
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadDashboardData();
        this.setupCharts();
    }

    bindEvents() {
        // Cambio de período
        document.getElementById('periodoSelect').addEventListener('change', (e) => {
            this.currentPeriod = e.target.value;
            this.isManualRefresh = true;
            this.loadDashboardData();
        });

        // Botón de refresh
        document.getElementById('btnRefresh').addEventListener('click', () => {
            this.isManualRefresh = true;
            this.loadDashboardData();
        });

        // Filtros de gráficas
        document.getElementById('filtroPedidos').addEventListener('change', () => {
            this.updatePedidosChart();
        });

        document.getElementById('filtroTiempos').addEventListener('change', () => {
            this.updateTiemposChart();
        });

        // Actualizar cada 30 segundos (solo si no es una actualización manual)
        setInterval(() => {
            this.isManualRefresh = false;
            this.loadDashboardData();
        }, 30000);
    }

    async loadDashboardData() {
        try {
            this.showLoading();

            // Cargar datos de todas las vistas necesarias para el dashboard
            const [
                statsData,
                pedidosPorEstadoData,
                entregasHoyData,
                entregasPorZonaData,
                incidenciasActivasData,
                tiempoPromedioData,
                productividadData,
                costosPorKMData
            ] = await Promise.all([
                this.fetchData('/api/dashboard/estadisticas'),
                this.fetchData('/api/vistas/pedidos-por-estado'),
                this.fetchData('/api/vistas/entregas-hoy'),
                this.fetchData('/api/vistas/entregas-zona'),
                this.fetchData('/api/vistas/incidencias-activas'),
                this.fetchData('/api/vistas/tiempo-promedio-entrega'),
                this.fetchData('/api/vistas/productividad-repartidores'),
                this.fetchData('/api/vistas/costos-km')
            ]);

            // Actualizar estadísticas principales
            this.updateStats(statsData.estadisticas);

            // Actualizar gráficas con datos reales
            this.updateEntregasChart(pedidosPorEstadoData);
            this.updatePedidosChart(entregasHoyData);
            this.updateZonasChart(entregasPorZonaData);
            this.updateTiemposChart(tiempoPromedioData);

            // Actualizar métricas secundarias
            this.updateSecondaryMetrics({
                incidenciasActivas: incidenciasActivasData,
                productividad: productividadData,
                costosPorKM: costosPorKMData
            });

            // Actualizar actividad reciente
            this.updateActivity(incidenciasActivasData);

            this.hideLoading();

        } catch (error) {
            console.error('Error loading dashboard:', error);

            // Solo mostrar error si es una actualización manual
            if (this.isManualRefresh) {
                this.showError('Error cargando datos del dashboard');
            }

            this.hideLoading();

            // Si hay error, cargar datos de respaldo
            this.loadFallbackData();
        }
    }

    async fetchData(url) {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`Error loading data from ${url}`);
            return await response.json();
        } catch (error) {
            console.error(`Error fetching data from ${url}:`, error);
            throw error;
        }
    }

    updateStats(data) {
        document.getElementById('totalPedidos').textContent = data.pedidos_pendientes || '0';
        document.getElementById('entregasExitosas').textContent = data.entregas_pendientes || '0';
        document.getElementById('rutasActivas').textContent = data.rutas_activas || '0';
        document.getElementById('tasaExito').textContent = `${data.tasa_exito || 0}%`;
    }

    updateSecondaryMetrics(data) {
        try {
            // Eficiencia de repartidores - usar datos de vProductividadRepartidor
            const eficienciaElement = document.getElementById('eficienciaRepartidores');
            const progressEficiencia = document.getElementById('progressEficiencia');

            if (eficienciaElement && progressEficiencia) {
                if (data.productividad && data.productividad.length > 0) {
                    const eficienciaPromedio = data.productividad.reduce((sum, item) =>
                        sum + parseFloat(item.Tasa_Exito_Porcentaje || 0), 0) / data.productividad.length;

                    eficienciaElement.textContent = `${Math.round(eficienciaPromedio)}%`;
                    progressEficiencia.style.width = `${Math.round(eficienciaPromedio)}%`;
                } else {
                    // Valores por defecto si no hay datos
                    eficienciaElement.textContent = '0%';
                    progressEficiencia.style.width = '0%';
                }
            } else {
                console.warn('Elementos de eficiencia no encontrados');
            }

            // Costo por KM - usar datos de vCostosPorKM
            const costoElement = document.getElementById('costoPorKm');
            const changeElement = document.getElementById('changeCostoKm');

            if (costoElement && changeElement) {
                if (data.costosPorKM && data.costosPorKM.length > 0) {
                    const costoPromedio = data.costosPorKM.reduce((sum, item) =>
                        sum + parseFloat(item.Costo_Por_KM || 0), 0) / data.costosPorKM.length;
                    costoElement.textContent = `$${costoPromedio.toFixed(2)}`;

                    // Calcular cambio porcentual (simulado, ya que no tenemos histórico)
                    const cambio = (Math.random() * 10 - 5).toFixed(1); // Entre -5% y +5%
                    changeElement.textContent = `${cambio > 0 ? '+' : ''}${cambio}%`;
                    changeElement.className = cambio > 0 ? 'metric-change positive' : 'metric-change negative';
                } else {
                    // Valores por defecto si no hay datos
                    costoElement.textContent = '$0.00';
                    changeElement.textContent = '0%';
                    changeElement.className = 'metric-change';
                }
            } else {
                console.warn('Elementos de costo por KM no encontrados');
            }

            // Incidencias activas - usar datos de vIncidenciasActivas
            const incidenciasElement = document.getElementById('incidenciasActivas');
            const badgeIncidencias = document.getElementById('badgeIncidencias');

            if (incidenciasElement && badgeIncidencias) {
                if (data.incidenciasActivas) {
                    const totalIncidencias = data.incidenciasActivas.length;
                    const incidenciasCriticas = data.incidenciasActivas.filter(item =>
                        item.Impacto === 'Crítico' || item.Impacto === 'Alto').length;

                    incidenciasElement.textContent = totalIncidencias;
                    badgeIncidencias.textContent = `${incidenciasCriticas} Críticas`;
                } else {
                    // Valores por defecto si no hay datos
                    incidenciasElement.textContent = '0';
                    badgeIncidencias.textContent = '0 Críticas';
                }
            } else {
                console.warn('Elementos de incidencias no encontrados');
            }

        } catch (error) {
            console.error('Error en updateSecondaryMetrics:', error);
        }
    }

    setupCharts() {
        // Inicializar charts con datos vacíos
        this.updateEntregasChart();
        this.updatePedidosChart();
        this.updateZonasChart();
        this.updateTiemposChart();
    }

    updateEntregasChart(data = null) {
        try {
            const containerId = "chartEntregas";

            // Si no llegan datos, usar datos por defecto
            if (!data || data.length === 0) {
                data = [
                    { nombre_estado: "Entregado", Total_Pedidos: 65 },
                    { nombre_estado: "En Camino", Total_Pedidos: 20 },
                    { nombre_estado: "Pendiente", Total_Pedidos: 10 },
                    { nombre_estado: "Cancelado", Total_Pedidos: 5 }
                ];
            }

            // Convertimos la data al formato de Highcharts
            const chartData = data.map(item => ({
                name: item.nombre_estado,
                y: item.Total_Pedidos
            }));

            // Si no hay valores válidos
            if (chartData.length === 0) {
                return mostrarMensajeGraficoVacio(containerId);
            }

            // Renderizamos gráfico Pie
            Highcharts.chart(containerId, {
                chart: {
                    type: "pie",
                    backgroundColor: "transparent"
                },
                title: {
                    text: "Pedidos por estado"
                },
                tooltip: {
                    pointFormat: "<b>{point.percentage:.1f}%</b> ({point.y} pedidos)"
                },
                accessibility: {
                    enabled: false
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: "pointer",
                        dataLabels: {
                            enabled: true,
                            format: "<b>{point.name}</b>: {point.percentage:.1f}%"
                        }
                    }
                },
                colors: [
                    "#4CAF50", // Verde
                    "#2196F3", // Azul
                    "#FFC107", // Amarillo
                    "#F44336", // Rojo
                    "#9C27B0", // Morado
                    "#FF9800"  // Naranja
                ],
                series: [{
                    name: "Pedidos",
                    colorByPoint: true,
                    data: chartData
                }]
            });

        } catch (error) {
            console.error("Error actualizando gráfico:", error);
            mostrarErrorGrafico("chartEntregas", "No se pudo cargar el gráfico");
        }
    }



    updatePedidosChart(data = null) {
        // Agrupar entregas por hora del día
        const entregasPorHora = {};

        if (data && data.length > 0) {
            data.forEach(entrega => {
                const hora = new Date(entrega.fecha_estimada_entrega).getHours();
                const rangoHora = `${hora}:00 - ${hora + 1}:00`;

                if (!entregasPorHora[rangoHora]) {
                    entregasPorHora[rangoHora] = 0;
                }
                entregasPorHora[rangoHora]++;
            });
        } else {
            // Datos de ejemplo si no hay datos reales
            for (let i = 8; i <= 18; i++) {
                entregasPorHora[`${i}:00 - ${i + 1}:00`] = Math.floor(Math.random() * 10) + 1;
            }
        }

        // Transformar datos para Highcharts
        const categories = Object.keys(entregasPorHora);
        const pedidosData = Object.values(entregasPorHora);

        // Destruir chart anterior si existe
        if (this.charts.pedidos) {
            this.charts.pedidos.destroy();
        }

        this.charts.pedidos = Highcharts.chart('chartPedidos', {
            chart: {
                type: 'column',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            xAxis: {
                categories: categories,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: { text: 'Entregas por Hora' }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y}</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0,
                    color: '#3498db'
                }
            },
            series: [{
                name: 'Entregas',
                data: pedidosData
            }],
            credits: { enabled: false }
        });
    }

    updateZonasChart(data = null) {
        // Si no hay datos, usar datos por defecto
        if (!data || data.length === 0) {
            data = [
                { nombre_zona: 'Zona Norte', Total_Entregas: 35 },
                { nombre_zona: 'Zona Sur', Total_Entregas: 25 },
                { nombre_zona: 'Zona Este', Total_Entregas: 20 },
                { nombre_zona: 'Zona Oeste', Total_Entregas: 15 },
                { nombre_zona: 'Centro', Total_Entregas: 5 }
            ];
        }

        // Transformar datos para Highcharts
        const zonasData = data.map(item => ({
            name: item.nombre_zona,
            y: item.Total_Entregas
        }));

        // Destruir chart anterior si existe
        if (this.charts.zonas) {
            this.charts.zonas.destroy();
        }

        this.charts.zonas = Highcharts.chart('chartZonas', {
            chart: {
                type: 'bar',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            xAxis: {
                type: 'category',
                labels: {
                    style: {
                        fontSize: '11px'
                    }
                }
            },
            yAxis: {
                min: 0,
                title: { text: 'Cantidad de Entregas' }
            },
            legend: {
                enabled: false
            },
            tooltip: {
                pointFormat: 'Entregas: <b>{point.y}</b>'
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    },
                    color: '#9b59b6'
                }
            },
            series: [{
                name: 'Entregas',
                data: zonasData
            }],
            credits: { enabled: false }
        });
    }

    updateTiemposChart(data = null) {
        // Si no hay datos, usar datos por defecto
        if (!data || !data.Tiempo_Promedio_Minutos) {
            data = { Tiempo_Promedio_Minutos: 45 };
        }

        const tiempoPromedio = parseFloat(data.Tiempo_Promedio_Minutos);

        // Crear distribución basada en el tiempo promedio
        let distribucion;
        if (tiempoPromedio < 30) {
            distribucion = [
                ['< 30 min', 60],
                ['30-60 min', 30],
                ['1-2 horas', 8],
                ['> 2 horas', 2]
            ];
        } else if (tiempoPromedio < 60) {
            distribucion = [
                ['< 30 min', 25],
                ['30-60 min', 50],
                ['1-2 horas', 20],
                ['> 2 horas', 5]
            ];
        } else if (tiempoPromedio < 120) {
            distribucion = [
                ['< 30 min', 10],
                ['30-60 min', 30],
                ['1-2 horas', 45],
                ['> 2 horas', 15]
            ];
        } else {
            distribucion = [
                ['< 30 min', 5],
                ['30-60 min', 15],
                ['1-2 horas', 30],
                ['> 2 horas', 50]
            ];
        }

        // Destruir chart anterior si existe
        if (this.charts.tiempos) {
            this.charts.tiempos.destroy();
        }

        this.charts.tiempos = Highcharts.chart('chartTiempos', {
            chart: {
                type: 'column',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            xAxis: {
                type: 'category'
            },
            yAxis: {
                min: 0,
                title: { text: 'Porcentaje' }
            },
            tooltip: {
                pointFormat: '<b>{point.y}%</b>'
            },
            plotOptions: {
                column: {
                    colorByPoint: true,
                    colors: ['#27ae60', '#3498db', '#f39c12', '#e74c3c']
                }
            },
            series: [{
                name: 'Tiempos',
                data: distribucion,
                color: '#f39c12'
            }],
            credits: { enabled: false }
        });
    }

    updateActivity(data = null) {
        const activityList = document.getElementById('activityList');

        // Si no hay datos, usar datos por defecto
        if (!data || data.length === 0) {
            data = [
                {
                    icon: 'fa-check-circle',
                    title: 'Entrega Exitosa',
                    description: 'Pedido #1234 entregado a Juan Pérez',
                    time: 'Hace 5 minutos',
                    colors: '#27ae60'
                },
                {
                    icon: 'fa-truck',
                    title: 'En Camino',
                    description: 'Pedido #1235 asignado a repartidor',
                    time: 'Hace 15 minutos',
                    colors: '#3498db'
                },
                {
                    icon: 'fa-exclamation-triangle',
                    title: 'Incidencia Reportada',
                    description: 'Bloqueo vial en Zona Norte',
                    time: 'Hace 25 minutos',
                    colors: '#f39c12'
                },
                {
                    icon: 'fa-shopping-cart',
                    title: 'Nuevo Pedido',
                    description: 'Pedido #1236 creado por María García',
                    time: 'Hace 1 hora',
                    colors: '#9b59b6'
                }
            ];
        } else {
            // Transformar datos de incidencias a formato de actividad
            data = data.slice(0, 4).map(incidencia => {
                let icon, color;

                switch (incidencia.Tipo_Incidencia) {
                    case 'Bloqueo Vial':
                        icon = 'fa-road';
                        color = '#e74c3c';
                        break;
                    case 'Accidente':
                        icon = 'fa-car-crash';
                        color = '#e74c3c';
                        break;
                    case 'Clima Adverso':
                        icon = 'fa-cloud-rain';
                        color = '#3498db';
                        break;
                    default:
                        icon = 'fa-exclamation-triangle';
                        color = '#f39c12';
                }

                // Calcular tiempo transcurrido
                const fechaInicio = new Date(incidencia.fecha_inicio);
                const ahora = new Date();
                const diffMs = ahora - fechaInicio;
                const diffMins = Math.floor(diffMs / 60000);
                const diffHours = Math.floor(diffMins / 60);
                const diffDays = Math.floor(diffHours / 24);

                let tiempoTranscurrido;
                if (diffMins < 60) {
                    tiempoTranscurrido = `Hace ${diffMins} minutos`;
                } else if (diffHours < 24) {
                    tiempoTranscurrido = `Hace ${diffHours} horas`;
                } else {
                    tiempoTranscurrido = `Hace ${diffDays} días`;
                }

                return {
                    icon: icon,
                    title: incidencia.Tipo_Incidencia,
                    description: `${incidencia.descripcion || 'Incidencia'} en ${incidencia.Zona_Afectada}`,
                    time: tiempoTranscurrido,
                    color: color
                };
            });
        }

        activityList.innerHTML = data.map(activity => `
            <div class="activity-item">
                <div class="activity-icon" style="background: ${activity.color}">
                    <i class="fas ${activity.icon}"></i>
                </div>
                <div class="activity-content">
                    <div class="activity-title">${activity.title}</div>
                    <div class="activity-description">${activity.description}</div>
                    <div class="activity-time">${activity.time}</div>
                </div>
            </div>
        `).join('');
    }

    loadFallbackData() {
        // Cargar datos de respaldo si hay error en la API
        this.updateStats({
            pedidos_pendientes: 45,
            entregas_pendientes: 38,
            rutas_activas: 12,
            tasa_exito: 85
        });

        this.updateSecondaryMetrics({});

        // Cargar gráficas con datos de respaldo
        this.updateEntregasChart();
        this.updatePedidosChart();
        this.updateZonasChart();
        this.updateTiemposChart();
        this.updateActivity();
    }

    showLoading() {
        const btnRefresh = document.getElementById('btnRefresh');
        btnRefresh.classList.add('loading');
        btnRefresh.disabled = true;
    }

    hideLoading() {
        const btnRefresh = document.getElementById('btnRefresh');
        btnRefresh.classList.remove('loading');
        btnRefresh.disabled = false;
    }

    showError(message) {
        // Implementar notificación de error que no afecte el CSS
        console.error('Dashboard Error:', message);

        // Crear un contenedor específico para notificaciones si no existe
        let notificationContainer = document.getElementById('notification-container');
        if (!notificationContainer) {
            notificationContainer = document.createElement('div');
            notificationContainer.id = 'notification-container';
            notificationContainer.style.position = 'fixed';
            notificationContainer.style.top = '20px';
            notificationContainer.style.right = '20px';
            notificationContainer.style.zIndex = '9999';
            notificationContainer.style.maxWidth = '300px';
            document.body.appendChild(notificationContainer);
        }

        // Crear la notificación de error
        const notification = document.createElement('div');
        notification.className = 'notification error';
        notification.style.backgroundColor = '#e74c3c';
        notification.style.color = 'white';
        notification.style.padding = '10px 15px';
        notification.style.borderRadius = '4px';
        notification.style.marginBottom = '10px';
        notification.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
        notification.textContent = message;

        // Agregar la notificación al contenedor
        notificationContainer.appendChild(notification);

        // Eliminar la notificación después de 5 segundos
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transition = 'opacity 0.5s';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 500);
        }, 5000);
    }
}

// Inicializar dashboard cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    window.dashboard = new Dashboard();
});