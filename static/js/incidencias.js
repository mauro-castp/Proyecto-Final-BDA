// incidencias.js - Gestión de Incidencias
class IncidenciasApp {
    constructor() {
        this.incidencias = [];
        this.zonas = [];
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            tipo: '',
            impacto: ''
        };
        this.incidenciaSeleccionada = null;
        this.init();
    }

    init() {
        console.log('🚨 Inicializando módulo de incidencias...');
        this.bindEvents();
        this.cargarDatosIniciales();
        this.cargarIncidencias();
    }

    bindEvents() {
        // Filtros
        document.getElementById('filtroEstado')?.addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
        });

        document.getElementById('filtroTipo')?.addEventListener('change', (e) => {
            this.filtros.tipo = e.target.value;
        });

        document.getElementById('filtroImpacto')?.addEventListener('change', (e) => {
            this.filtros.impacto = e.target.value;
        });

        // Paginación
        document.getElementById('btnAnterior')?.addEventListener('click', () => {
            if (this.paginaActual > 1) {
                this.paginaActual--;
                this.cargarIncidencias();
            }
        });

        document.getElementById('btnSiguiente')?.addEventListener('click', () => {
            if (this.paginaActual < this.totalPaginas) {
                this.paginaActual++;
                this.cargarIncidencias();
            }
        });

        // Fecha actual como predeterminada en modales
        const ahora = new Date();
        document.getElementById('fechaInicio').value = ahora.toISOString().slice(0, 16);
    }

    // ==================== CARGA DE DATOS ====================
    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarZonas(),
                this.cargarAlertasActivas()
            ]);
        } catch (error) {
            console.error('Error cargando datos iniciales:', error);
            this.mostrarError('Error cargando datos del sistema');
        }
    }

    async cargarIncidencias() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                ...this.filtros
            });

            const response = await fetch(`/api/incidencias?${params}`, {
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}: ${response.statusText}`);

            const data = await response.json();
            this.incidencias = Array.isArray(data) ? data : (data.incidencias || []);

            this.totalPaginas = data.totalPaginas || Math.ceil(this.incidencias.length / this.registrosPorPagina);

            this.actualizarTabla();
            this.actualizarEstadisticas();
            this.actualizarPaginacion();

        } catch (error) {
            console.error('Error cargando incidencias:', error);
            this.mostrarError('Error cargando la lista de incidencias: ' + error.message);
        }
    }

    async cargarZonas() {
        try {
            // En una implementación real, tendrías un endpoint para zonas
            // Por ahora simulamos la carga
            this.zonas = [
                { id_zona: 1, nombre_zona: 'Zona Norte' },
                { id_zona: 2, nombre_zona: 'Zona Sur' },
                { id_zona: 3, nombre_zona: 'Zona Este' },
                { id_zona: 4, nombre_zona: 'Zona Oeste' },
                { id_zona: 5, nombre_zona: 'Zona Centro' }
            ];

            // Llenar select de zonas
            const select = document.getElementById('zonaIncidencia');
            if (select) {
                select.innerHTML = '<option value="">Seleccionar zona...</option>' +
                    this.zonas.map(zona =>
                        `<option value="${zona.id_zona}">${zona.nombre_zona}</option>`
                    ).join('');
            }
        } catch (error) {
            console.error('Error cargando zonas:', error);
        }
    }

    async cargarAlertasActivas() {
        try {
            const incidenciasActivas = this.incidencias.filter(incidencia =>
                incidencia.id_estado_incidencia === 1 // Activas
            );

            this.actualizarAlertas(incidenciasActivas);
        } catch (error) {
            console.error('Error cargando alertas:', error);
        }
    }

    // ==================== RENDERIZADO ====================
    actualizarTabla() {
        const tbody = document.getElementById('tablaIncidencias');
        if (!tbody) return;

        if (this.incidencias.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="10" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span>No se encontraron incidencias</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.incidencias.map(incidencia => `
            <tr class="${this.obtenerClaseUrgencia(incidencia)}">
                <td>
                    <span class="tipo-badge tipo-${this.getTipoSlug(incidencia.id_tipo_incidencia)}">
                        ${this.getTipoTexto(incidencia.id_tipo_incidencia)}
                    </span>
                </td>
                <td>
                    <div class="descripcion-corta" title="${incidencia.descripcion || 'Sin descripción'}">
                        ${this.acortarTexto(incidencia.descripcion || 'Sin descripción', 50)}
                    </div>
                </td>
                <td>${this.getNombreZona(incidencia.id_zona)}</td>
                <td>${this.formatearFechaHora(incidencia.fecha_inicio)}</td>
                <td>${incidencia.fecha_fin ? this.formatearFechaHora(incidencia.fecha_fin) : 'En curso'}</td>
                <td>
                    <span class="impacto-badge impacto-${this.getImpactoSlug(incidencia.id_nivel_impacto)}">
                        ${this.getImpactoTexto(incidencia.id_nivel_impacto)}
                    </span>
                </td>
                <td>
                    <span class="estado-badge estado-${this.getEstadoSlug(incidencia.id_estado_incidencia)}">
                        ${this.getEstadoTexto(incidencia.id_estado_incidencia)}
                    </span>
                </td>
                <td>${incidencia.nombre_usuario || 'Sistema'}</td>
                <td class="acciones-cell">
                    <button class="btn-action btn-view" onclick="incidenciasApp.verDetalles(${incidencia.id_incidencia})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${this.puedeEditar(incidencia) ? `
                        <button class="btn-action btn-edit" onclick="incidenciasApp.mostrarModalActualizar(${incidencia.id_incidencia})" title="Actualizar estado">
                            <i class="fas fa-edit"></i>
                        </button>
                    ` : ''}
                    ${this.puedeResolver(incidencia) ? `
                        <button class="btn-action btn-resolve" onclick="incidenciasApp.resolverIncidencia(${incidencia.id_incidencia})" title="Marcar como resuelta">
                            <i class="fas fa-check"></i>
                        </button>
                    ` : ''}
                </td>
            </tr>
        `).join('');
    }

    actualizarEstadisticas() {
        const total = this.incidencias.length;
        const activas = this.incidencias.filter(i => i.id_estado_incidencia === 1).length;
        const altas = this.incidencias.filter(i => i.id_nivel_impacto === 3).length;

        // Calcular tiempo promedio de resolución (ejemplo)
        const incidenciasResueltas = this.incidencias.filter(i => i.id_estado_incidencia === 3 && i.fecha_fin);
        let promedioResolucion = 0;

        if (incidenciasResueltas.length > 0) {
            const totalHoras = incidenciasResueltas.reduce((sum, inc) => {
                const inicio = new Date(inc.fecha_inicio);
                const fin = new Date(inc.fecha_fin);
                const horas = (fin - inicio) / (1000 * 60 * 60);
                return sum + horas;
            }, 0);
            promedioResolucion = totalHoras / incidenciasResueltas.length;
        }

        document.getElementById('totalIncidencias').textContent = total;
        document.getElementById('incidenciasActivas').textContent = activas;
        document.getElementById('incidenciasAltas').textContent = altas;
        document.getElementById('promedioResolucion').textContent = `${promedioResolucion.toFixed(1)}h`;
    }

    actualizarAlertas(incidenciasActivas) {
        const container = document.getElementById('alertasContainer');
        const lista = document.getElementById('alertasList');
        const contador = document.getElementById('contadorAlertas');

        if (incidenciasActivas.length === 0) {
            container.style.display = 'none';
            return;
        }

        container.style.display = 'block';
        contador.textContent = incidenciasActivas.length;

        lista.innerHTML = incidenciasActivas.map(incidencia => `
            <div class="alerta-item">
                <div class="alerta-icon ${this.getImpactoSlug(incidencia.id_nivel_impacto)}">
                    <i class="fas fa-exclamation"></i>
                </div>
                <div class="alerta-content">
                    <div class="alerta-titulo">
                        ${this.getTipoTexto(incidencia.id_tipo_incidencia)} - ${this.getNombreZona(incidencia.id_zona)}
                    </div>
                    <div class="alerta-descripcion">
                        ${this.acortarTexto(incidencia.descripcion, 80)}
                    </div>
                </div>
                <div class="alerta-acciones">
                    <button class="btn-action btn-view btn-sm" onclick="incidenciasApp.verDetalles(${incidencia.id_incidencia})">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>
        `).join('');
    }

    actualizarPaginacion() {
        const btnAnterior = document.getElementById('btnAnterior');
        const btnSiguiente = document.getElementById('btnSiguiente');
        const paginationNumbers = document.getElementById('paginationNumbers');
        const mostrandoDesde = document.getElementById('mostrandoDesde');
        const mostrandoHasta = document.getElementById('mostrandoHasta');
        const totalRegistros = document.getElementById('totalRegistros');

        if (btnAnterior) btnAnterior.disabled = this.paginaActual === 1;
        if (btnSiguiente) btnSiguiente.disabled = this.paginaActual === this.totalPaginas;

        const inicio = ((this.paginaActual - 1) * this.registrosPorPagina) + 1;
        const fin = Math.min(this.paginaActual * this.registrosPorPagina, this.incidencias.length);

        if (mostrandoDesde) mostrandoDesde.textContent = inicio;
        if (mostrandoHasta) mostrandoHasta.textContent = fin;
        if (totalRegistros) totalRegistros.textContent = this.incidencias.length;

        if (paginationNumbers) {
            paginationNumbers.innerHTML = '';
            for (let i = 1; i <= this.totalPaginas; i++) {
                const btn = document.createElement('button');
                btn.className = `btn-pagination ${i === this.paginaActual ? 'active' : ''}`;
                btn.textContent = i;
                btn.onclick = () => {
                    this.paginaActual = i;
                    this.cargarIncidencias();
                };
                paginationNumbers.appendChild(btn);
            }
        }
    }

    // ==================== LÓGICA DE ESTADOS ====================
    obtenerClaseUrgencia(incidencia) {
        if (incidencia.id_nivel_impacto === 3) return 'urgencia-alta';
        if (incidencia.id_nivel_impacto === 2) return 'urgencia-media';
        return 'urgencia-baja';
    }

    puedeEditar(incidencia) {
        return ['Admin', 'Planificador'].includes(window.userRole);
    }

    puedeResolver(incidencia) {
        return this.puedeEditar(incidencia) && incidencia.id_estado_incidencia === 1;
    }

    getTipoSlug(idTipo) {
        const tipos = {
            1: 'bloqueo',
            2: 'clima',
            3: 'vehiculo',
            4: 'seguridad',
            5: 'otro'
        };
        return tipos[idTipo] || 'otro';
    }

    getTipoTexto(idTipo) {
        const tipos = {
            1: 'Bloqueo Vial',
            2: 'Condiciones Climáticas',
            3: 'Problema Vehicular',
            4: 'Problema de Seguridad',
            5: 'Otro'
        };
        return tipos[idTipo] || 'Desconocido';
    }

    getEstadoSlug(idEstado) {
        const estados = {
            1: 'activa',
            2: 'monitoreo',
            3: 'resuelta'
        };
        return estados[idEstado] || 'activa';
    }

    getEstadoTexto(idEstado) {
        const estados = {
            1: 'Activa',
            2: 'En Monitoreo',
            3: 'Resuelta'
        };
        return estados[idEstado] || 'Desconocido';
    }

    getImpactoSlug(idImpacto) {
        const impactos = {
            1: 'bajo',
            2: 'medio',
            3: 'alto'
        };
        return impactos[idImpacto] || 'bajo';
    }

    getImpactoTexto(idImpacto) {
        const impactos = {
            1: 'Bajo',
            2: 'Medio',
            3: 'Alto'
        };
        return impactos[idImpacto] || 'Desconocido';
    }

    getNombreZona(idZona) {
        const zona = this.zonas.find(z => z.id_zona == idZona);
        return zona ? zona.nombre_zona : `Zona ${idZona}`;
    }

    // ==================== MODALES ====================
    mostrarModalRegistrar() {
        this.cerrarTodosModales();
        document.getElementById('modalRegistrarIncidencia').style.display = 'block';
    }

    cerrarModalRegistrar() {
        document.getElementById('modalRegistrarIncidencia').style.display = 'none';
        document.getElementById('formRegistrarIncidencia').reset();

        // Restablecer fecha actual
        const ahora = new Date();
        document.getElementById('fechaInicio').value = ahora.toISOString().slice(0, 16);
    }

    async verDetalles(idIncidencia) {
        this.incidenciaSeleccionada = idIncidencia;

        try {
            const response = await fetch(`/api/incidencias/${idIncidencia}`);
            if (response.ok) {
                const incidencia = await response.json();
                this.mostrarModalDetalles(incidencia);
            } else {
                // Buscar en datos locales
                const incidencia = this.incidencias.find(i => i.id_incidencia == idIncidencia);
                if (incidencia) {
                    this.mostrarModalDetalles(incidencia);
                } else {
                    throw new Error('Incidencia no encontrada');
                }
            }
        } catch (error) {
            console.error('Error cargando detalles:', error);
            this.mostrarError('Error al cargar los detalles de la incidencia');
        }
    }

    mostrarModalDetalles(incidencia) {
        document.getElementById('detalleId').textContent = incidencia.id_incidencia;
        document.getElementById('detalleTipo').textContent = this.getTipoTexto(incidencia.id_tipo_incidencia);
        document.getElementById('detalleEstado').textContent = this.getEstadoTexto(incidencia.id_estado_incidencia);
        document.getElementById('detalleImpacto').textContent = this.getImpactoTexto(incidencia.id_nivel_impacto);
        document.getElementById('detalleZona').textContent = this.getNombreZona(incidencia.id_zona);
        document.getElementById('detalleFechaInicio').textContent = this.formatearFechaHora(incidencia.fecha_inicio);
        document.getElementById('detalleFechaFin').textContent = incidencia.fecha_fin ?
            this.formatearFechaHora(incidencia.fecha_fin) : 'En curso';
        document.getElementById('detalleReportadaPor').textContent = incidencia.nombre_usuario || 'Sistema';
        document.getElementById('detalleDescripcion').textContent = incidencia.descripcion || 'Sin descripción';
        document.getElementById('detalleObservaciones').textContent = incidencia.observaciones || 'Sin observaciones';

        this.cerrarTodosModales();
        document.getElementById('modalDetallesIncidencia').style.display = 'block';
    }

    cerrarModalDetalles() {
        document.getElementById('modalDetallesIncidencia').style.display = 'none';
        this.incidenciaSeleccionada = null;
    }

    async mostrarModalActualizar(idIncidencia) {
        this.incidenciaSeleccionada = idIncidencia;

        try {
            const response = await fetch(`/api/incidencias/${idIncidencia}`);
            if (response.ok) {
                const incidencia = await response.json();
                document.getElementById('incidenciaIdActualizar').value = idIncidencia;
                document.getElementById('estadoIncidencia').value = incidencia.id_estado_incidencia;

                if (incidencia.id_estado_incidencia === 3 && incidencia.fecha_fin) {
                    document.getElementById('fechaResolucion').value = incidencia.fecha_fin.slice(0, 16);
                } else {
                    document.getElementById('fechaResolucion').value = '';
                }
            }
        } catch (error) {
            console.error('Error cargando datos para actualizar:', error);
        }

        this.cerrarTodosModales();
        document.getElementById('modalActualizarIncidencia').style.display = 'block';
    }

    cerrarModalActualizar() {
        document.getElementById('modalActualizarIncidencia').style.display = 'none';
        document.getElementById('formActualizarIncidencia').reset();
        this.incidenciaSeleccionada = null;
    }

    cerrarTodosModales() {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.style.display = 'none';
        });
    }

    // ==================== ACCIONES ====================
    async registrarIncidencia() {
        const form = document.getElementById('formRegistrarIncidencia');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            id_tipo_incidencia: parseInt(formData.get('tipoIncidencia')),
            id_zona: parseInt(formData.get('zonaIncidencia')),
            descripcion: formData.get('descripcionIncidencia'),
            fecha_inicio: formData.get('fechaInicio') + ':00',
            fecha_fin: formData.get('fechaFin') ? formData.get('fechaFin') + ':00' : null,
            id_nivel_impacto: parseInt(formData.get('nivelImpacto')),
            observaciones: formData.get('observacionesIncidencia') || ''
        };

        try {
            const response = await fetch('/api/incidencias', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) throw new Error('Error registrando incidencia');

            this.mostrarExito('Incidencia registrada correctamente');
            this.cerrarModalRegistrar();
            this.cargarIncidencias();

        } catch (error) {
            console.error('Error registrando incidencia:', error);
            this.mostrarError('Error al registrar la incidencia: ' + error.message);
        }
    }

    async actualizarIncidencia() {
        const form = document.getElementById('formActualizarIncidencia');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            id_estado_incidencia: parseInt(formData.get('estadoIncidencia')),
            fecha_fin: formData.get('fechaResolucion') ? formData.get('fechaResolucion') + ':00' : null,
            comentario: formData.get('comentarioActualizacion')
        };

        try {
            // En una implementación real, tendrías un endpoint para actualizar incidencias
            // Por ahora simulamos la actualización
            console.log('Actualizando incidencia:', this.incidenciaSeleccionada, data);

            this.mostrarExito('Incidencia actualizada correctamente');
            this.cerrarModalActualizar();
            this.cargarIncidencias();

        } catch (error) {
            console.error('Error actualizando incidencia:', error);
            this.mostrarError('Error al actualizar la incidencia: ' + error.message);
        }
    }

    async resolverIncidencia(idIncidencia) {
        if (!confirm('¿Está seguro de que desea marcar esta incidencia como resuelta?')) {
            return;
        }

        try {
            // Simular resolución
            console.log('Resolviendo incidencia:', idIncidencia);

            this.mostrarExito('Incidencia marcada como resuelta');
            this.cargarIncidencias();

        } catch (error) {
            console.error('Error resolviendo incidencia:', error);
            this.mostrarError('Error al resolver la incidencia: ' + error.message);
        }
    }

    // ==================== UTILIDADES ====================
    aplicarFiltros() {
        this.paginaActual = 1;
        this.cargarIncidencias();
    }

    formatearFechaHora(fechaString) {
        if (!fechaString) return 'N/A';
        try {
            const fecha = new Date(fechaString);
            return fecha.toLocaleDateString('es-ES') + ' ' + fecha.toLocaleTimeString('es-ES', {
                hour: '2-digit',
                minute: '2-digit'
            });
        } catch (e) {
            return 'N/A';
        }
    }

    acortarTexto(texto, longitud) {
        if (!texto) return '';
        return texto.length > longitud ? texto.substring(0, longitud) + '...' : texto;
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaIncidencias');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="10" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-spinner fa-spin"></i>
                            <span>Cargando incidencias...</span>
                        </div>
                    </td>
                </tr>
            `;
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
    window.incidenciasApp = new IncidenciasApp();
});

// Manejar clics fuera de los modales para cerrarlos
window.addEventListener('click', function (event) {
    const modals = document.querySelectorAll('.modal');
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
});