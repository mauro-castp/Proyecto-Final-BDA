// reportes.js - Sistema de Reportes con Highcharts
class ReportesApp {
    constructor() {
        this.charts = {};
        this.datosReporte = {};
        this.filtros = {
            desde: '',
            hasta: '',
            tipo: 'otp'
        };
        this.init();
    }

    init() {
        console.log('📊 Inicializando módulo de reportes...');
        this.bindEvents();
        this.cargarDatosIniciales();
        this.inicializarGraficas();
    }

    bindEvents() {
        // Filtros
        document.getElementById('fechaDesde')?.addEventListener('change', (e) => {
            this.filtros.desde = e.target.value;
        });

        document.getElementById('fechaHasta')?.addEventListener('change', (e) => {
            this.filtros.hasta = e.target.value;
        });

        document.getElementById('tipoReporte')?.addEventListener('change', (e) => {
            this.filtros.tipo = e.target.value;
        });

        // Establecer fechas por defecto (últimos 30 días)
        const hoy = new Date();
        const hace30Dias = new Date();
        hace30Dias.setDate(hoy.getDate() - 30);

        document.getElementById('fechaDesde').value = hace30Dias.toISOString().split('T')[0];
        document.getElementById('fechaHasta').value = hoy.toISOString().split('T')[0];

        this.filtros.desde = hace30Dias.toISOString().split('T')[0];
        this.filtros.hasta = hoy.toISOString().split('T')[0];
    }

    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarKPIs(),
                this.cargarReporteOTP(),
                this.cargarReporteCostos(),
                this.cargarReporteEntregas(),
                this.cargarReporteProductividad()
            ]);
        } catch (error) {
            console.error('Error cargando datos iniciales:', error);
            this.mostrarError('Error cargando datos de reportes');
        }
    }

    inicializarGraficas() {
        // Inicializar contenedores de gráficas
        this.inicializarGraficaOTP();
        this.inicializarGraficaCostos();
        this.inicializarGraficaEntregas();
        this.inicializarGraficaProductividad();
    }

    // ==================== MÉTODOS DE CARGA DE DATOS ====================
    async cargarKPIs() {
        try {
            // En una implementación real, tendrías un endpoint para KPIs consolidados
            // Por ahora simulamos datos
            document.getElementById('kpiOtp').textContent = '87.5%';
            document.getElementById('kpiCostoKm').textContent = '$15.80';
            document.getElementById('kpiIncidencias').textContent = '3';
            document.getElementById('kpiEntregas').textContent = '45';
        } catch (error) {
            console.error('Error cargando KPIs:', error);
        }
    }

    async cargarReporteOTP() {
        try {
            const params = new URLSearchParams({
                desde: this.filtros.desde,
                hasta: this.filtros.hasta
            });

            const response = await fetch(`/api/reportes/otp?${params}`);
            if (response.ok) {
                const data = await response.json();
                this.datosReporte.otp = data;
                this.actualizarGraficaOTP(data);
                this.actualizarTablaReporte(data, 'otp');
            } else {
                // Datos de ejemplo para desarrollo
                this.generarDatosEjemploOTP();
            }
        } catch (error) {
            console.error('Error cargando reporte OTP:', error);
            this.generarDatosEjemploOTP();
        }
    }

    async cargarReporteCostos() {
        try {
            const params = new URLSearchParams({
                desde: this.filtros.desde,
                hasta: this.filtros.hasta
            });

            const response = await fetch(`/api/reportes/costos-km?${params}`);
            if (response.ok) {
                const data = await response.json();
                this.datosReporte.costos = data;
                this.actualizarGraficaCostos(data);
            } else {
                this.generarDatosEjemploCostos();
            }
        } catch (error) {
            console.error('Error cargando reporte costos:', error);
            this.generarDatosEjemploCostos();
        }
    }

    async cargarReporteEntregas() {
        try {
            // Usar vista de entregas por zona
            const response = await fetch('/api/reportes/entregas-zona');
            if (response.ok) {
                const data = await response.json();
                this.datosReporte.entregas = data;
                this.actualizarGraficaEntregas(data);
            } else {
                this.generarDatosEjemploEntregas();
            }
        } catch (error) {
            console.error('Error cargando reporte entregas:', error);
            this.generarDatosEjemploEntregas();
        }
    }

    async cargarReporteProductividad() {
        try {
            const params = new URLSearchParams({
                desde: this.filtros.desde,
                hasta: this.filtros.hasta
            });

            const response = await fetch(`/api/reportes/productividad?${params}`);
            if (response.ok) {
                const data = await response.json();
                this.datosReporte.productividad = data;
                this.actualizarGraficaProductividad(data);
            } else {
                this.generarDatosEjemploProductividad();
            }
        } catch (error) {
            console.error('Error cargando reporte productividad:', error);
            this.generarDatosEjemploProductividad();
        }
    }

    // ==================== MÉTODOS DE GRÁFICAS ====================
    inicializarGraficaOTP() {
        this.charts.otp = Highcharts.chart('chartOtp', {
            chart: {
                type: 'column',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            xAxis: {
                type: 'category',
                labels: {
                    rotation: -45,
                    style: {
                        fontSize: '11px'
                    }
                }
            },
            yAxis: {
                title: { text: 'OTP (%)' },
                min: 0,
                max: 100
            },
            series: [{
                name: 'OTP',
                data: [],
                color: '#3498db'
            }],
            tooltip: {
                pointFormat: '<b>{point.y:.1f}%</b>'
            },
            credits: { enabled: false },
            legend: { enabled: false }
        });
    }

    inicializarGraficaCostos() {
        this.charts.costos = Highcharts.chart('chartCostos', {
            chart: {
                type: 'line',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            xAxis: {
                type: 'category'
            },
            yAxis: {
                title: { text: 'Costo por KM ($)' }
            },
            series: [{
                name: 'Costo por KM',
                data: [],
                color: '#27ae60'
            }],
            tooltip: {
                pointFormat: '<b>${point.y:.2f}</b> por KM'
            },
            credits: { enabled: false },
            legend: { enabled: false }
        });
    }

    inicializarGraficaEntregas() {
        this.charts.entregas = Highcharts.chart('chartEntregas', {
            chart: {
                type: 'pie',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            series: [{
                name: 'Entregas',
                data: [],
                colors: ['#3498db', '#2ecc71', '#e74c3c', '#f39c12', '#9b59b6']
            }],
            tooltip: {
                pointFormat: '<b>{point.y} entregas</b> ({point.percentage:.1f}%)'
            },
            credits: { enabled: false },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                    }
                }
            }
        });
    }

    inicializarGraficaProductividad() {
        this.charts.productividad = Highcharts.chart('chartProductividad', {
            chart: {
                type: 'column',
                backgroundColor: 'transparent'
            },
            title: { text: null },
            xAxis: {
                type: 'category'
            },
            yAxis: {
                title: { text: 'Entregas Realizadas' }
            },
            series: [{
                name: 'Entregas',
                data: [],
                color: '#f39c12'
            }],
            tooltip: {
                pointFormat: '<b>{point.y} entregas</b>'
            },
            credits: { enabled: false },
            legend: { enabled: false }
        });
    }

    // ==================== ACTUALIZACIÓN DE GRÁFICAS ====================
    actualizarGraficaOTP(datos) {
        if (!this.charts.otp) return;

        const data = datos.map(item => [
            item.nombre_ruta || `Ruta ${item.id_ruta}`,
            parseFloat(item.otp_percentage) || 0
        ]);

        this.charts.otp.series[0].setData(data);
    }

    actualizarGraficaCostos(datos) {
        if (!this.charts.costos) return;

        const data = datos.map(item => [
            item.zona || `Zona ${item.id_zona}`,
            parseFloat(item.costo_km) || 0
        ]);

        this.charts.costos.series[0].setData(data);
    }

    actualizarGraficaEntregas(datos) {
        if (!this.charts.entregas) return;

        const data = datos.map(item => ({
            name: item.nombre_zona || `Zona ${item.id_zona}`,
            y: parseInt(item.total_entregas) || 0
        }));

        this.charts.entregas.series[0].setData(data);
    }

    actualizarGraficaProductividad(datos) {
        if (!this.charts.productividad) return;

        const data = datos.map(item => [
            item.nombre_repartidor || `Repartidor ${item.id_repartidor}`,
            parseInt(item.entregas_realizadas) || 0
        ]);

        this.charts.productividad.series[0].setData(data);
    }

    // ==================== INTERFAZ PRINCIPAL ====================
    async generarReporte() {
        const tipo = this.filtros.tipo;

        try {
            this.mostrarCargando(true);

            switch (tipo) {
                case 'otp':
                    await this.cargarReporteOTP();
                    break;
                case 'costos':
                    await this.cargarReporteCostos();
                    break;
                case 'productividad':
                    await this.cargarReporteProductividad();
                    break;
                case 'entregas':
                    await this.cargarReporteEntregas();
                    break;
                case 'incidencias':
                    await this.cargarReporteIncidencias();
                    break;
            }

            this.mostrarExito(`Reporte de ${this.getNombreReporte(tipo)} generado correctamente`);
        } catch (error) {
            console.error('Error generando reporte:', error);
            this.mostrarError('Error generando el reporte: ' + error.message);
        } finally {
            this.mostrarCargando(false);
        }
    }

    actualizarGrafica(tipo) {
        switch (tipo) {
            case 'otp':
                this.cargarReporteOTP();
                break;
            case 'costos':
                this.cargarReporteCostos();
                break;
            case 'entregas':
                this.cargarReporteEntregas();
                break;
            case 'productividad':
                this.cargarReporteProductividad();
                break;
        }
    }

    // ==================== TABLA DE DATOS ====================
    actualizarTablaReporte(datos, tipo) {
        const thead = document.getElementById('tablaReportesHead');
        const tbody = document.getElementById('tablaReportesBody');

        if (!datos || datos.length === 0) {
            thead.innerHTML = '<tr><th colspan="5" class="text-center">No hay datos para mostrar</th></tr>';
            tbody.innerHTML = '';
            return;
        }

        // Configurar encabezados según el tipo de reporte
        switch (tipo) {
            case 'otp':
                thead.innerHTML = `
                    <tr>
                        <th>Ruta</th>
                        <th>OTP (%)</th>
                        <th>Entregas Totales</th>
                        <th>Entregas a Tiempo</th>
                        <th>Eficiencia</th>
                    </tr>
                `;
                tbody.innerHTML = datos.map(item => `
                    <tr>
                        <td>${item.nombre_ruta || `Ruta ${item.id_ruta}`}</td>
                        <td class="${this.getClaseEficiencia(item.otp_percentage)}">
                            <strong>${parseFloat(item.otp_percentage || 0).toFixed(1)}%</strong>
                        </td>
                        <td>${item.total_entregas || 0}</td>
                        <td>${item.entregas_a_tiempo || 0}</td>
                        <td>${this.getTextoEficiencia(item.otp_percentage)}</td>
                    </tr>
                `).join('');
                break;

            case 'costos':
                thead.innerHTML = `
                    <tr>
                        <th>Zona</th>
                        <th>Costo por KM</th>
                        <th>Distancia Total</th>
                        <th>Costo Total</th>
                        <th>Eficiencia</th>
                    </tr>
                `;
                tbody.innerHTML = datos.map(item => `
                    <tr>
                        <td>${item.nombre_zona || `Zona ${item.id_zona}`}</td>
                        <td>$${parseFloat(item.costo_km || 0).toFixed(2)}</td>
                        <td>${parseFloat(item.distancia_total || 0).toFixed(1)} km</td>
                        <td>$${parseFloat(item.costo_total || 0).toFixed(2)}</td>
                        <td class="${this.getClaseEficienciaCosto(item.costo_km)}">
                            ${this.getTextoEficienciaCosto(item.costo_km)}
                        </td>
                    </tr>
                `).join('');
                break;

            case 'productividad':
                thead.innerHTML = `
                    <tr>
                        <th>Repartidor</th>
                        <th>Entregas Realizadas</th>
                        <th>OTP Promedio</th>
                        <th>Horas Trabajadas</th>
                        <th>Productividad</th>
                    </tr>
                `;
                tbody.innerHTML = datos.map(item => `
                    <tr>
                        <td>${item.nombre_repartidor || `Repartidor ${item.id_repartidor}`}</td>
                        <td>${item.entregas_realizadas || 0}</td>
                        <td>${parseFloat(item.otp_promedio || 0).toFixed(1)}%</td>
                        <td>${parseFloat(item.horas_trabajadas || 0).toFixed(1)}</td>
                        <td class="${this.getClaseProductividad(item.entregas_realizadas)}">
                            ${this.getTextoProductividad(item.entregas_realizadas)}
                        </td>
                    </tr>
                `).join('');
                break;
        }
    }

    // ==================== UTILIDADES ====================
    getClaseEficiencia(otp) {
        const valor = parseFloat(otp) || 0;
        if (valor >= 90) return 'kpi-positivo';
        if (valor >= 80) return 'kpi-neutral';
        return 'kpi-negativo';
    }

    getTextoEficiencia(otp) {
        const valor = parseFloat(otp) || 0;
        if (valor >= 90) return 'Excelente';
        if (valor >= 80) return 'Buena';
        if (valor >= 70) return 'Regular';
        return 'Baja';
    }

    getClaseEficienciaCosto(costo) {
        const valor = parseFloat(costo) || 0;
        if (valor <= 15) return 'kpi-positivo';
        if (valor <= 20) return 'kpi-neutral';
        return 'kpi-negativo';
    }

    getTextoEficienciaCosto(costo) {
        const valor = parseFloat(costo) || 0;
        if (valor <= 15) return 'Excelente';
        if (valor <= 20) return 'Aceptable';
        return 'Alto';
    }

    getClaseProductividad(entregas) {
        const valor = parseInt(entregas) || 0;
        if (valor >= 40) return 'kpi-positivo';
        if (valor >= 25) return 'kpi-neutral';
        return 'kpi-negativo';
    }

    getTextoProductividad(entregas) {
        const valor = parseInt(entregas) || 0;
        if (valor >= 40) return 'Alta';
        if (valor >= 25) return 'Media';
        return 'Baja';
    }

    getNombreReporte(tipo) {
        const nombres = {
            'otp': 'OTP por Ruta',
            'costos': 'Costos por KM',
            'productividad': 'Productividad',
            'entregas': 'Entregas por Zona',
            'incidencias': 'Incidencias por Tipo'
        };
        return nombres[tipo] || 'Reporte';
    }

    // ==================== DATOS DE EJEMPLO (PARA DESARROLLO) ====================
    generarDatosEjemploOTP() {
        const datos = [
            { id_ruta: 1, nombre_ruta: 'Ruta Norte', otp_percentage: 92.5, total_entregas: 45, entregas_a_tiempo: 42 },
            { id_ruta: 2, nombre_ruta: 'Ruta Sur', otp_percentage: 85.2, total_entregas: 38, entregas_a_tiempo: 32 },
            { id_ruta: 3, nombre_ruta: 'Ruta Este', otp_percentage: 78.9, total_entregas: 52, entregas_a_tiempo: 41 },
            { id_ruta: 4, nombre_ruta: 'Ruta Oeste', otp_percentage: 95.1, total_entregas: 29, entregas_a_tiempo: 28 },
            { id_ruta: 5, nombre_ruta: 'Ruta Centro', otp_percentage: 88.3, total_entregas: 67, entregas_a_tiempo: 59 }
        ];
        this.datosReporte.otp = datos;
        this.actualizarGraficaOTP(datos);
        this.actualizarTablaReporte(datos, 'otp');
    }

    generarDatosEjemploCostos() {
        const datos = [
            { id_zona: 1, nombre_zona: 'Zona Norte', costo_km: 14.50, distancia_total: 120.5, costo_total: 1747.25 },
            { id_zona: 2, nombre_zona: 'Zona Sur', costo_km: 16.20, distancia_total: 95.8, costo_total: 1551.96 },
            { id_zona: 3, nombre_zona: 'Zona Este', costo_km: 12.80, distancia_total: 145.2, costo_total: 1858.56 },
            { id_zona: 4, nombre_zona: 'Zona Oeste', costo_km: 18.90, distancia_total: 78.3, costo_total: 1480.47 },
            { id_zona: 5, nombre_zona: 'Zona Centro', costo_km: 22.10, distancia_total: 65.7, costo_total: 1451.97 }
        ];
        this.datosReporte.costos = datos;
        this.actualizarGraficaCostos(datos);
        this.actualizarTablaReporte(datos, 'costos');
    }

    generarDatosEjemploEntregas() {
        const datos = [
            { id_zona: 1, nombre_zona: 'Zona Norte', total_entregas: 145 },
            { id_zona: 2, nombre_zona: 'Zona Sur', total_entregas: 98 },
            { id_zona: 3, nombre_zona: 'Zona Este', total_entregas: 167 },
            { id_zona: 4, nombre_zona: 'Zona Oeste', total_entregas: 76 },
            { id_zona: 5, nombre_zona: 'Zona Centro', total_entregas: 234 }
        ];
        this.datosReporte.entregas = datos;
        this.actualizarGraficaEntregas(datos);
    }

    generarDatosEjemploProductividad() {
        const datos = [
            { id_repartidor: 1, nombre_repartidor: 'Carlos Rodríguez', entregas_realizadas: 45, otp_promedio: 92.1, horas_trabajadas: 38.5 },
            { id_repartidor: 2, nombre_repartidor: 'Ana Martínez', entregas_realizadas: 52, otp_promedio: 88.7, horas_trabajadas: 42.0 },
            { id_repartidor: 3, nombre_repartidor: 'Luis García', entregas_realizadas: 38, otp_promedio: 85.2, horas_trabajadas: 36.5 },
            { id_repartidor: 4, nombre_repartidor: 'María López', entregas_realizadas: 61, otp_promedio: 94.3, horas_trabajadas: 44.0 },
            { id_repartidor: 5, nombre_repartidor: 'Pedro Sánchez', entregas_realizadas: 29, otp_promedio: 79.8, horas_trabajadas: 32.5 }
        ];
        this.datosReporte.productividad = datos;
        this.actualizarGraficaProductividad(datos);
        this.actualizarTablaReporte(datos, 'productividad');
    }

    // ==================== EXPORTACIÓN ====================
    exportarReporte() {
        this.mostrarInfo('Funcionalidad de exportación en desarrollo');
    }

    exportarTabla() {
        this.mostrarInfo('Exportación a CSV en desarrollo');
    }

    // ==================== UTILIDADES DE UI ====================
    mostrarCargando(mostrar = true) {
        const botones = document.querySelectorAll('.reportes-header button');
        botones.forEach(btn => {
            btn.disabled = mostrar;
        });

        if (mostrar) {
            document.body.classList.add('loading');
        } else {
            document.body.classList.remove('loading');
        }
    }

    mostrarExito(mensaje) {
        this.mostrarNotificacion(mensaje, 'success');
    }

    mostrarError(mensaje) {
        this.mostrarNotificacion(mensaje, 'error');
    }

    mostrarInfo(mensaje) {
        this.mostrarNotificacion(mensaje, 'info');
    }

    mostrarNotificacion(mensaje, tipo = 'info') {
        // Implementación simple de notificación
        console.log(`[${tipo.toUpperCase()}] ${mensaje}`);
        alert(`[${tipo.toUpperCase()}] ${mensaje}`);
    }
}

// Inicializar la aplicación
document.addEventListener('DOMContentLoaded', function () {
    window.reportesApp = new ReportesApp();
});