// incidencias.js - Gestión de Incidencias con SweetAlert2
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

        // ✅ CORREGIDO: Establecer fecha actual como predeterminada en modales
        this.establecerFechaActual();

        const formRegistrar = document.getElementById('formRegistrarIncidencia');
        if (formRegistrar) {
            formRegistrar.addEventListener('submit', (e) => {
                e.preventDefault(); // Prevenir envío real del formulario
            });
        }

        document.querySelectorAll('#formRegistrarIncidencia .form-control[required]').forEach(input => {
            input.addEventListener('change', () => {
                if (input.value) {
                    input.style.border = '';
                }
            });
        });
    }

    establecerFechaActual() {
        const ahora = new Date();

        // Compensar la zona horaria para datetime-local
        const offset = ahora.getTimezoneOffset() * 60000; // offset en milisegundos
        const fechaLocal = new Date(ahora.getTime() - offset);

        const fechaFormateada = fechaLocal.toISOString().slice(0, 16);

        const fechaInicioInput = document.getElementById('fechaInicio');
        if (fechaInicioInput) {
            fechaInicioInput.value = fechaFormateada;
            console.log('✅ Fecha de inicio establecida:', fechaInicioInput.value);
        }
    }

    // ==================== SWEETALERT2 ====================
    mostrarError(mensaje) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: mensaje,
            confirmButtonText: 'Aceptar',
            confirmButtonColor: '#dc3545'
        });
    }

    mostrarExito(mensaje) {
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: mensaje,
            confirmButtonText: 'Aceptar',
            confirmButtonColor: '#28a745',
            timer: 3000,
            timerProgressBar: true
        });
    }

    mostrarConfirmacion(mensaje, textoConfirmar = 'Sí, eliminar', textoCancelar = 'Cancelar') {
        return Swal.fire({
            icon: 'warning',
            title: 'Confirmar acción',
            text: mensaje,
            showCancelButton: true,
            confirmButtonText: textoConfirmar,
            cancelButtonText: textoCancelar,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            reverseButtons: true
        });
    }

    mostrarCargando(titulo = 'Procesando...') {
        Swal.fire({
            title: titulo,
            allowOutsideClick: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
    }

    cerrarCargando() {
        Swal.close();
    }

    // ==================== CARGA DE DATOS ====================
    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarZonas(),
                this.cargarEstadisticas()
            ]);
        } catch (error) {
            console.error('Error cargando datos iniciales:', error);
            this.mostrarError('Error cargando datos del sistema');
        }
    }

    async cargarIncidencias() {
        try {
            this.mostrarCargando('Cargando incidencias...');

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                estado: this.filtros.estado,
                tipo: this.filtros.tipo,
                impacto: this.filtros.impacto
            });

            const data = await this.handleFetch(`/api/incidencias?${params}`);

            this.incidencias = data.incidencias || [];
            this.totalPaginas = data.paginacion?.total_paginas || 1;

            this.actualizarTabla();
            this.actualizarEstadisticas();
            this.actualizarPaginacion(data.paginacion);
            this.actualizarAlertas(this.incidencias.filter(i => i.id_estado_incidencia === 1));

            this.cerrarCargando();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error cargando incidencias:', error);
            this.mostrarError('Error cargando la lista de incidencias: ' + error.message);
        }
    }

    async cargarZonas() {
        try {
            const response = await fetch('/api/zonas');
            if (response.ok) {
                this.zonas = await response.json();
            } else {
                // Fallback si el endpoint no existe
                this.zonas = [
                    { id_zona: 1, nombre_zona: 'Zona Norte' },
                    { id_zona: 2, nombre_zona: 'Zona Sur' },
                    { id_zona: 3, nombre_zona: 'Zona Este' },
                    { id_zona: 4, nombre_zona: 'Zona Oeste' },
                    { id_zona: 5, nombre_zona: 'Zona Centro' }
                ];
            }

            // Llenar select de zonas en modal
            const select = document.getElementById('zonaIncidencia');
            if (select) {
                select.innerHTML = '<option value="">Seleccionar zona...</option>' +
                    this.zonas.map(zona =>
                        `<option value="${zona.id_zona}">${zona.nombre_zona}</option>`
                    ).join('');
            }
        } catch (error) {
            console.error('Error cargando zonas:', error);
            // Usar valores por defecto en caso de error
            this.zonas = [
                { id_zona: 1, nombre_zona: 'Zona Norte' },
                { id_zona: 2, nombre_zona: 'Zona Sur' },
                { id_zona: 3, nombre_zona: 'Zona Este' },
                { id_zona: 4, nombre_zona: 'Zona Oeste' },
                { id_zona: 5, nombre_zona: 'Zona Centro' }
            ];
        }
    }

    async cargarEstadisticas() {
        try {
            const stats = await this.handleFetch('/api/incidencias/estadisticas');
            this.actualizarEstadisticas(stats);
        } catch (error) {
            console.error('Error cargando estadísticas:', error);
            // Usar estadísticas por defecto
            this.actualizarEstadisticas({
                total: 0,
                activas: 0,
                altas: 0,
                promedio_resolucion: 0
            });
        }
    }

    // ==================== RENDERIZADO ====================
    actualizarTabla() {
        const tbody = document.getElementById('tablaIncidencias');
        if (!tbody) return;

        if (this.incidencias.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="9" class="text-center">
                        <div class="no-data">
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
                    ${this.puedeEliminar(incidencia) ? `
                        <button class="btn-action btn-delete" onclick="incidenciasApp.eliminarIncidencia(${incidencia.id_incidencia})" title="Eliminar incidencia">
                            <i class="fas fa-trash"></i>
                        </button>
                    ` : ''}
                </td>
            </tr>
        `).join('');
    }

    actualizarEstadisticas(stats = null) {
        if (stats) {
            // Usar estadísticas del servidor
            document.getElementById('totalIncidencias').textContent = stats.total || 0;
            document.getElementById('incidenciasActivas').textContent = stats.activas || 0;
            document.getElementById('incidenciasAltas').textContent = stats.altas || 0;
            document.getElementById('promedioResolucion').textContent = `${(stats.promedio_resolucion || 0).toFixed(1)}h`;
        } else {
            // Calcular estadísticas locales
            const total = this.incidencias.length;
            const activas = this.incidencias.filter(i => i.id_estado_incidencia === 1).length;
            const altas = this.incidencias.filter(i => i.id_nivel_impacto === 3).length;

            document.getElementById('totalIncidencias').textContent = total;
            document.getElementById('incidenciasActivas').textContent = activas;
            document.getElementById('incidenciasAltas').textContent = altas;
        }
    }

    actualizarAlertas(incidenciasActivas) {
        const container = document.getElementById('alertasContainer');
        const lista = document.getElementById('alertasList');
        const contador = document.getElementById('contadorAlertas');

        if (!incidenciasActivas || incidenciasActivas.length === 0) {
            if (container) container.style.display = 'none';
            return;
        }

        if (container) container.style.display = 'block';
        if (contador) contador.textContent = incidenciasActivas.length;

        if (lista) {
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
    }

    actualizarPaginacion(paginacion = null) {
        const btnAnterior = document.getElementById('btnAnterior');
        const btnSiguiente = document.getElementById('btnSiguiente');
        const paginationNumbers = document.getElementById('paginationNumbers');
        const mostrandoDesde = document.getElementById('mostrandoDesde');
        const mostrandoHasta = document.getElementById('mostrandoHasta');
        const totalRegistros = document.getElementById('totalRegistros');

        if (paginacion) {
            this.totalPaginas = paginacion.total_paginas || 1;
            this.registrosPorPagina = paginacion.limite || this.registrosPorPagina;
        }

        const totalRegistrosCount = paginacion?.total_registros || this.incidencias.length;
        const inicio = ((this.paginaActual - 1) * this.registrosPorPagina) + 1;
        const fin = Math.min(this.paginaActual * this.registrosPorPagina, totalRegistrosCount);

        if (btnAnterior) btnAnterior.disabled = this.paginaActual === 1;
        if (btnSiguiente) btnSiguiente.disabled = this.paginaActual === this.totalPaginas;
        if (mostrandoDesde) mostrandoDesde.textContent = inicio;
        if (mostrandoHasta) mostrandoHasta.textContent = fin;
        if (totalRegistros) totalRegistros.textContent = totalRegistrosCount;

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
        // Admin, Supervisor, Planificador pueden editar
        return ['Admin', 'Supervisor', 'Planificador'].includes(window.userRole || 'Admin');
    }

    puedeEliminar(incidencia) {
        // Solo Admin y Supervisor pueden eliminar, y solo incidencias no resueltas
        return ['Admin', 'Supervisor'].includes(window.userRole || 'Admin') && incidencia.id_estado_incidencia !== 3;
    }

    getTipoSlug(idTipo) {
        const tipos = { 1: 'bloqueo', 2: 'clima', 3: 'vehiculo', 4: 'seguridad', 5: 'otro' };
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
        const estados = { 1: 'activa', 2: 'monitoreo', 3: 'resuelta' };
        return estados[idEstado] || 'activa';
    }

    getEstadoTexto(idEstado) {
        const estados = { 1: 'Activa', 2: 'En Monitoreo', 3: 'Resuelta' };
        return estados[idEstado] || 'Desconocido';
    }

    getImpactoSlug(idImpacto) {
        const impactos = { 1: 'bajo', 2: 'medio', 3: 'alto' };
        return impactos[idImpacto] || 'bajo';
    }

    getImpactoTexto(idImpacto) {
        const impactos = { 1: 'Bajo', 2: 'Medio', 3: 'Alto' };
        return impactos[idImpacto] || 'Desconocido';
    }

    getNombreZona(idZona) {
        const zona = this.zonas.find(z => z.id_zona == idZona);
        return zona ? zona.nombre_zona : `Zona ${idZona}`;
    }

    // ==================== MODALES ====================
    mostrarModalRegistrar() {
        this.cerrarTodosModales();

        // ✅ Asegurar que la fecha se establezca justo antes de mostrar el modal
        this.establecerFechaActual();

        document.getElementById('modalRegistrarIncidencia').style.display = 'block';

        // ✅ Debug: verificar el valor después de mostrar el modal
        setTimeout(() => {
            const fechaInicioInput = document.getElementById('fechaInicio');
            console.log('🔍 Fecha después de abrir modal:', fechaInicioInput?.value);
        }, 100);
    }

    cerrarModalRegistrar() {
        document.getElementById('modalRegistrarIncidencia').style.display = 'none';
        document.getElementById('formRegistrarIncidencia').reset();

        // ✅ Restablecer fecha actual después de reset
        setTimeout(() => {
            this.establecerFechaActual();
        }, 100);
    }

    async verDetalles(idIncidencia) {
        try {
            this.mostrarCargando('Cargando detalles...');

            const incidencia = await this.handleFetch(`/api/incidencias/${idIncidencia}`);
            this.mostrarModalDetalles(incidencia);

            this.cerrarCargando();
        } catch (error) {
            this.cerrarCargando();
            // Buscar en datos locales como fallback
            const incidenciaLocal = this.incidencias.find(i => i.id_incidencia == idIncidencia);
            if (incidenciaLocal) {
                this.mostrarModalDetalles(incidenciaLocal);
            } else {
                this.mostrarError('Error al cargar los detalles de la incidencia: ' + error.message);
            }
        }
    }

    mostrarModalDetalles(incidencia) {
        // Llenar datos en el modal de detalles
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
        console.log('🔧 === INICIANDO mostrarModalActualizar ===');
        console.log('🔧 ID Incidencia:', idIncidencia);

        this.cerrarTodosModales();

        try {
            console.log('🔧 Haciendo fetch a la API...');
            const response = await fetch(`/api/incidencias/${idIncidencia}`);

            if (!response.ok) {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }

            const incidencia = await response.json();
            console.log('📋 Datos COMPLETOS de la incidencia:', incidencia);

            // OBTENER ELEMENTOS DEL DOM
            const estadoSelect = document.getElementById('estadoIncidencia');
            const fechaResolucion = document.getElementById('fechaResolucion');
            const comentario = document.getElementById('comentarioActualizacion');
            const idInput = document.getElementById('incidenciaIdActualizar');

            if (!estadoSelect) {
                console.error('❌ ERROR: estadoSelect no encontrado');
                this.mostrarError('Error: formulario no cargado');
                return;
            }

            // VERIFICAR VALOR DEL ESTADO DESDE LA API
            console.log('🎯 Estado desde API:', incidencia.id_estado_incidencia, 'Tipo:', typeof incidencia.id_estado_incidencia);

            // ESTABLECER VALORES CON MÁS SEGURIDAD
            if (idInput) {
                idInput.value = idIncidencia;
                console.log('✅ ID establecido:', idInput.value);
            }

            // ESTADO - CON VALIDACIÓN ROBUSTA
            if (incidencia.id_estado_incidencia !== undefined && incidencia.id_estado_incidencia !== null) {
                estadoSelect.value = incidencia.id_estado_incidencia.toString();
                console.log('✅ Estado establecido:', estadoSelect.value);
            } else {
                // Si no hay estado, usar "Activa" por defecto
                estadoSelect.value = '1';
                console.log('⚠️ Estado no definido, usando valor por defecto 1');
            }

            // FECHA RESOLUCIÓN
            if (fechaResolucion) {
                if (incidencia.fecha_fin) {
                    // Convertir a formato datetime-local
                    const fecha = new Date(incidencia.fecha_fin);
                    const fechaFormateada = fecha.toISOString().slice(0, 16);
                    fechaResolucion.value = fechaFormateada;
                    console.log('✅ Fecha resolución establecida:', fechaResolucion.value);
                } else {
                    fechaResolucion.value = '';
                    console.log('✅ Fecha resolución vacía');
                }
            }

            // COMENTARIO - siempre vacío al abrir
            if (comentario) {
                comentario.value = '';
                console.log('✅ Comentario vacío');
            }

            console.log('✅ Todos los valores establecidos correctamente');

        } catch (error) {
            console.error('❌ ERROR cargando datos:', error);
            // En caso de error, establecer valores por defecto
            const estadoSelect = document.getElementById('estadoIncidencia');
            if (estadoSelect) {
                estadoSelect.value = '1';
                console.log('🔄 Usando valores por defecto por error');
            }
        }

        // MOSTRAR MODAL
        console.log('🪟 Mostrando modal...');
        document.getElementById('modalActualizarIncidencia').style.display = 'block';

        // VERIFICACIÓN FINAL
        setTimeout(() => {
            const estadoSelectFinal = document.getElementById('estadoIncidencia');
            console.log('🔍 VERIFICACIÓN FINAL - estadoSelect.value:', estadoSelectFinal?.value);
        }, 200);
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

        // ✅ OBTENER VALORES DIRECTAMENTE EN LUGAR DE USAR FormData
        const tipoIncidencia = document.getElementById('tipoIncidencia').value;
        const zonaIncidencia = document.getElementById('zonaIncidencia').value;
        const descripcionIncidencia = document.getElementById('descripcionIncidencia').value;
        const fechaInicioInput = document.getElementById('fechaInicio');
        const fechaFinInput = document.getElementById('fechaFin');
        const nivelImpacto = document.getElementById('nivelImpacto').value;
        const observacionesIncidencia = document.getElementById('observacionesIncidencia').value;

        // Obtener valores directamente de los inputs
        const fechaInicio = fechaInicioInput ? fechaInicioInput.value : null;
        const fechaFin = fechaFinInput && fechaFinInput.value ? fechaFinInput.value : null;

        console.log('📅 Fecha inicio capturada directamente:', fechaInicio);
        console.log('📅 Fecha fin capturada directamente:', fechaFin);

        // Validar campos requeridos
        if (!tipoIncidencia || !zonaIncidencia || !descripcionIncidencia || !fechaInicio || !nivelImpacto) {
            this.mostrarError('Por favor complete todos los campos requeridos');

            // Resaltar campos vacíos
            if (!tipoIncidencia) document.getElementById('tipoIncidencia').style.border = '2px solid red';
            if (!zonaIncidencia) document.getElementById('zonaIncidencia').style.border = '2px solid red';
            if (!descripcionIncidencia) document.getElementById('descripcionIncidencia').style.border = '2px solid red';
            if (!fechaInicio) {
                fechaInicioInput.style.border = '2px solid red';
                fechaInicioInput.focus();
            }
            if (!nivelImpacto) document.getElementById('nivelImpacto').style.border = '2px solid red';

            return;
        }

        // Resetear bordes
        document.querySelectorAll('.form-control').forEach(input => {
            input.style.border = '';
        });

        const data = {
            id_tipo_incidencia: parseInt(tipoIncidencia),
            id_zona: parseInt(zonaIncidencia),
            descripcion: descripcionIncidencia,
            fecha_inicio: fechaInicio + ':00',
            fecha_fin: fechaFin ? fechaFin + ':00' : null,
            id_nivel_impacto: parseInt(nivelImpacto),
            observaciones: observacionesIncidencia || ''
        };

        console.log('📦 Datos a enviar para crear incidencia:', data);

        try {
            this.mostrarCargando('Registrando incidencia...');

            const response = await fetch('/api/incidencias', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error registrando incidencia');
            }

            this.cerrarCargando();
            this.mostrarExito('Incidencia registrada correctamente');
            this.cerrarModalRegistrar();
            this.cargarIncidencias();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error registrando incidencia:', error);
            this.mostrarError('Error al registrar la incidencia: ' + error.message);
        }
    }

    // Agrega esto temporalmente en el init() para debug
    init() {
        console.log('🚨 Inicializando módulo de incidencias...');

        // Debug temporal: verificar elementos del formulario
        setTimeout(() => {
            const fechaInicioInput = document.getElementById('fechaInicio');
            console.log('🔍 Estado del campo fechaInicio:', {
                existe: !!fechaInicioInput,
                valor: fechaInicioInput?.value,
                tipo: fechaInicioInput?.type
            });
        }, 1000);

        this.bindEvents();
        this.cargarDatosIniciales();
        this.cargarIncidencias();
    }

    async actualizarIncidencia() {
        console.log('🚀 === INICIANDO actualizarIncidencia ===');
        console.log('🚀 ID Incidencia seleccionada:', this.incidenciaSeleccionada);

        // Obtener elementos del DOM
        const estadoSelect = document.getElementById('estadoIncidencia');
        const fechaResolucion = document.getElementById('fechaResolucion');
        const comentarioInput = document.getElementById('comentarioActualizacion');

        console.log('🔍 Elementos encontrados:');
        console.log(' - estadoSelect:', estadoSelect);
        console.log(' - fechaResolucion:', fechaResolucion);
        console.log(' - comentarioInput:', comentarioInput);

        if (!estadoSelect) {
            console.error('❌ ERROR: estadoSelect no encontrado');
            this.mostrarError('Error: formulario no cargado');
            return;
        }

        // VERIFICAR VALOR DEL SELECT CON MÁS DETALLE
        console.log('📊 VALOR ACTUAL del estadoSelect:');
        console.log(' - estadoSelect.value:', estadoSelect.value);
        console.log(' - estadoSelect.selectedIndex:', estadoSelect.selectedIndex);

        if (estadoSelect.selectedIndex >= 0) {
            console.log(' - Opción seleccionada:', estadoSelect.options[estadoSelect.selectedIndex].text);
        }

        const estadoValue = estadoSelect.value;
        console.log('📊 estadoValue extraído:', estadoValue, 'Tipo:', typeof estadoValue);

        // VALIDACIÓN MÁS ESTRICTA
        if (!estadoValue || estadoValue === '') {
            console.error('❌ ERROR: estadoValue está vacío');
            this.mostrarError('Por favor seleccione un estado válido para la incidencia');
            estadoSelect.focus();
            estadoSelect.style.border = '2px solid red';
            return;
        }

        // VALIDAR QUE SEA UN NÚMERO VÁLIDO
        const estadoNumerico = parseInt(estadoValue);
        if (isNaN(estadoNumerico) || estadoNumerico < 1 || estadoNumerico > 3) {
            console.error('❌ ERROR: estadoValue no es un número válido');
            this.mostrarError('El estado seleccionado no es válido');
            return;
        }

        // VALIDAR COMENTARIO
        const comentarioValue = comentarioInput ? comentarioInput.value.trim() : '';
        console.log('📊 comentarioValue:', comentarioValue);

        if (!comentarioValue) {
            console.error('❌ ERROR: comentario vacío');
            this.mostrarError('Por favor ingrese un comentario de actualización');
            if (comentarioInput) {
                comentarioInput.focus();
                comentarioInput.style.border = '2px solid red';
            }
            return;
        }

        // PREPARAR DATOS
        console.log('📦 Preparando datos para enviar...');
        const data = {
            id_estado_incidencia: estadoNumerico, // Ya validado como número
            comentario: comentarioValue
        };

        // Solo incluir fecha_fin si tiene valor
        if (fechaResolucion && fechaResolucion.value) {
            data.fecha_fin = fechaResolucion.value + ':00';
            console.log('📅 Fecha fin incluida:', data.fecha_fin);
        }

        console.log('📦 Datos FINALES a enviar:', JSON.stringify(data, null, 2));

        try {
            console.log('🔄 Enviando solicitud PUT...');
            this.mostrarCargando('Actualizando incidencia...');

            const result = await this.handleFetch(`/api/incidencias/${this.incidenciaSeleccionada}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            console.log('✅ Respuesta del servidor:', result);
            this.cerrarCargando();
            this.mostrarExito('Incidencia actualizada correctamente');
            this.cerrarModalActualizar();
            this.cargarIncidencias();

        } catch (error) {
            this.cerrarCargando();
            console.error('❌ ERROR en actualizarIncidencia:', error);
            this.mostrarError('Error al actualizar la incidencia: ' + error.message);
        }

        console.log('✅ === FIN actualizarIncidencia ===');
    }

    async eliminarIncidencia(idIncidencia) {
        try {
            const result = await this.mostrarConfirmacion(
                '¿Está seguro de que desea eliminar esta incidencia? Esta acción no se puede deshacer.',
                'Sí, eliminar',
                'Cancelar'
            );

            if (!result.isConfirmed) {
                return;
            }

            this.mostrarCargando('Eliminando incidencia...');

            const data = await this.handleFetch(`/api/incidencias/${idIncidencia}`, {
                method: 'DELETE'
            });

            this.cerrarCargando();
            this.mostrarExito('Incidencia eliminada exitosamente');
            this.cargarIncidencias();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error eliminando incidencia:', error);
            this.mostrarError(error.message || 'Error al eliminar la incidencia');
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

    async handleFetch(url, options = {}) {
        try {
            const response = await fetch(url, options);

            // Verificar si la respuesta es JSON
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                const textResponse = await response.text();
                console.error('Respuesta no JSON recibida:', {
                    url,
                    status: response.status,
                    statusText: response.statusText,
                    response: textResponse.substring(0, 500)
                });
                throw new Error(`Error del servidor: ${response.status} ${response.statusText}`);
            }

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || `Error: ${response.status}`);
            }

            return result;
        } catch (error) {
            console.error('Error en fetch:', error);
            throw error;
        }
    }
}

// Inicializar la aplicación
document.addEventListener('DOMContentLoaded', function () {
    window.incidenciasApp = new IncidenciasApp();
    window.userRole = 'Admin'; // Esto debería venir de tu sistema de autenticación
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