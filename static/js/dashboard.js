class Dashboard {
    constructor() {
        this.currentPeriod = 'mes';
        this.charts = {};
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
            this.loadDashboardData();
        });

        // Botón de refresh
        document.getElementById('btnRefresh').addEventListener('click', () => {
            this.loadDashboardData();
        });

        // Filtros de gráficas
        document.getElementById('filtroPedidos').addEventListener('change', () => {
            this.updatePedidosChart();
        });

        document.getElementById('filtroTiempos').addEventListener('change', () => {
            this.updateTiemposChart();
        });

        // Actualizar cada 30 segundos
        setInterval(() => {
            this.loadDashboardData();
        }, 30000);
    }

    async loadDashboardData() {
        try {
            this.showLoading();

            const [statsData, chartsData, activityData] = await Promise.all([
                this.loadStats(),
                this.loadChartsData(),
                this.loadActivity()
            ]);

            this.updateStats(statsData);
            this.updateCharts(chartsData);
            this.updateActivity(activityData);
            this.updateSecondaryMetrics(statsData);

            this.hideLoading();

        } catch (error) {
            console.error('Error loading dashboard:', error);
            this.showError('Error cargando datos del dashboard');
            this.hideLoading();
        }
    }

    async loadStats() {
        const response = await fetch(`/api/dashboard/estadisticas?periodo=${this.currentPeriod}`);
        if (!response.ok) throw new Error('Error loading stats');
        return await response.json();
    }

    async loadChartsData() {
        const response = await fetch(`/api/dashboard/graficas?periodo=${this.currentPeriod}`);
        if (!response.ok) throw new Error('Error loading charts');
        return await response.json();
    }

    async loadActivity() {
        const response = await fetch(`/api/dashboard/actividad?periodo=${this.currentPeriod}`);
        if (!response.ok) throw new Error('Error loading activity');
        return await response.json();
    }

    updateStats(data) {
        document.getElementById('totalPedidos').textContent = data.total_pedidos || '0';
        document.getElementById('entregasExitosas').textContent = data.entregas_exitosas || '0';
        document.getElementById('rutasActivas').textContent = data.rutas_activas || '0';
        document.getElementById('tasaExito').textContent = data.tasa_exito || '0%';
    }

    updateSecondaryMetrics(data) {
        // Métricas simuladas - en producción vendrían del API
        document.getElementById('eficienciaRepartidores').textContent = '78%';
        document.getElementById('progressEficiencia').style.width = '78%';
        document.getElementById('costoPorKm').textContent = '$2.45';
        document.getElementById('changeCostoKm').textContent = '+5%';
        document.getElementById('incidenciasActivas').textContent = data.incidencias_activas || '0';
        document.getElementById('badgeIncidencias').textContent = '2 Críticas';
    }

    setupCharts() {
        // Inicializar charts con datos vacíos
        this.updateEntregasChart();
        this.updatePedidosChart();
        this.updateZonasChart();
        this.updateTiemposChart();
    }

    updateCharts(data) {
        this.updateEntregasChart(data.entregas_estado);
        this.updatePedidosChart(data.pedidos_dia);
        this.updateZonasChart(data.entregas_zona);
        this.updateTiemposChart(data.tiempos_entrega);
    }

    updateEntregasChart(data = null) {
        const chartData = data || [
            { name: 'Entregado', y: 65, color: '#27ae60' },
            { name: 'En Camino', y: 20, color: '#3498db' },
            { name: 'Pendiente', y: 10, color: '#f39c12' },
            { name: 'Fallido', y: 5, color: '#e74c3c' }
        ];

        this.charts.entregas = Highcharts.chart('chartEntregas', {
            chart: {
                type: 'pie',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            tooltip: {
                pointFormat: '<b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f}%',
                        distance: -30,
                        style: {
                            fontWeight: 'bold',
                            color: 'white',
                            textOutline: '1px contrast'
                        }
                    },
                    showInLegend: true
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle'
            },
            series: [{
                name: 'Entregas',
                colorByPoint: true,
                data: chartData
            }],
            credits: { enabled: false }
        });
    }

    updatePedidosChart(data = null) {
        const categories = data?.categories || ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
        const pedidosData = data?.data || [45, 52, 38, 61, 55, 40, 35];

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
                title: { text: 'Cantidad de Pedidos' }
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
                name: 'Pedidos',
                data: pedidosData
            }],
            credits: { enabled: false }
        });
    }

    updateZonasChart(data = null) {
        const zonasData = data || [
            { name: 'Zona Norte', y: 35 },
            { name: 'Zona Sur', y: 25 },
            { name: 'Zona Este', y: 20 },
            { name: 'Zona Oeste', y: 15 },
            { name: 'Centro', y: 5 }
        ];

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
        const tiemposData = data || [
            ['< 30 min', 25],
            ['30-60 min', 45],
            ['1-2 horas', 20],
            ['> 2 horas', 10]
        ];

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
                data: tiemposData,
                color: '#f39c12'
            }],
            credits: { enabled: false }
        });
    }

    updateActivity(data = null) {
        const activityList = document.getElementById('activityList');
        const activities = data || [
            {
                icon: 'fa-check-circle',
                title: 'Entrega Exitosa',
                description: 'Pedido #1234 entregado a Juan Pérez',
                time: 'Hace 5 minutos',
                color: '#27ae60'
            },
            {
                icon: 'fa-truck',
                title: 'En Camino',
                description: 'Pedido #1235 asignado a repartidor',
                time: 'Hace 15 minutos',
                color: '#3498db'
            },
            {
                icon: 'fa-exclamation-triangle',
                title: 'Incidencia Reportada',
                description: 'Bloqueo vial en Zona Norte',
                time: 'Hace 25 minutos',
                color: '#f39c12'
            },
            {
                icon: 'fa-shopping-cart',
                title: 'Nuevo Pedido',
                description: 'Pedido #1236 creado por María García',
                time: 'Hace 1 hora',
                color: '#9b59b6'
            }
        ];

        activityList.innerHTML = activities.map(activity => `
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
        // Implementar notificación de error
        console.error('Dashboard Error:', message);
    }
}

// Inicializar dashboard cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    window.dashboard = new Dashboard();
});