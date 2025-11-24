class CompaniesApp {
    constructor() {
        this.empresas = [];
        this.estadosEmpresa = [];
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.totalRegistros = 0;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            busqueda: ''
        };
        this.init();
    }

    init() {
        this.bindEvents();
        this.cargarEmpresas();
    }

    bindEvents() {
        // Filtros
        document.getElementById('filtroEstado').addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
        });

        document.getElementById('filtroBusqueda').addEventListener('input', (e) => {
            this.filtros.busqueda = e.target.value;
        });

        // Paginación
        document.getElementById('btnAnterior').addEventListener('click', () => {
            if (this.paginaActual > 1) {
                this.paginaActual--;
                this.cargarEmpresas();
            }
        });

        document.getElementById('btnSiguiente').addEventListener('click', () => {
            if (this.paginaActual < this.totalPaginas) {
                this.paginaActual++;
                this.cargarEmpresas();
            }
        });
    }

    async cargarEmpresas() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                ...this.filtros
            });

            const response = await fetch(`/api/empresas?${params}`);
            if (!response.ok) throw new Error('Error cargando empresas');

            const data = await response.json();
            this.empresas = data.empresas || [];
            this.totalPaginas = data.paginacion?.total_paginas || 1;
            this.totalRegistros = data.paginacion?.total_registros ?? this.empresas.length;
            this.registrosPorPagina = data.paginacion?.limite || this.registrosPorPagina;

            this.actualizarTabla();
            this.actualizarEstadisticas(data.estadisticas || {});
            this.actualizarPaginacion(data.paginacion);

        } catch (error) {
            console.error('Error cargando empresas:', error);
            this.mostrarError('Error cargando la lista de empresas');
        }
    }

    actualizarTabla() {
        const tbody = document.getElementById('tablaEmpresas');

        if (this.empresas.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-building"></i>
                            <span>No se encontraron empresas</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.empresas.map(empresa => `
            <tr>
                <td>
                    <div class="empresa-info">
                        <strong>${empresa.nombre || 'N/A'}</strong>
                    </div>
                </td>
                <td>${empresa.telefono || 'No especificado'}</td>
                <td>${empresa.email || 'No especificado'}</td>
                <td>
                    <div class="direccion-truncada" title="${empresa.direccion || ''}">
                        ${empresa.direccion ? this.truncarTexto(empresa.direccion, 50) : 'No especificada'}
                    </div>
                </td>
                <td>
                    <span class="estado-badge estado-${this.obtenerEstadoClase(empresa.id_estado_empresa)}">
                        ${this.obtenerEstadoTexto(empresa.id_estado_empresa)}
                    </span>
                </td>
                <td>${this.formatearFecha(empresa.fecha_creacion)}</td>
                <td class="acciones-cell">
                    <button class="btn-action btn-view" onclick="companiesApp.verDetalles(${empresa.id_empresa})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn-action btn-edit" onclick="companiesApp.editarEmpresa(${empresa.id_empresa})" title="Editar">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-action btn-delete" onclick="companiesApp.eliminarEmpresa(${empresa.id_empresa})" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    }

    obtenerEstadoClase(idEstado) {
        const estados = {
            1: 'activa',
            2: 'inactiva',
            3: 'suspendida'
        };
        return estados[idEstado] || 'inactiva';
    }

    obtenerEstadoTexto(idEstado) {
        const estados = {
            1: 'Activa',
            2: 'Inactiva',
            3: 'Suspendida'
        };
        return estados[idEstado] || 'Inactiva';
    }

    truncarTexto(texto, longitud) {
        if (texto.length <= longitud) return texto;
        return texto.substring(0, longitud) + '...';
    }

    actualizarEstadisticas(estadisticas = {}) {
        document.getElementById('totalEmpresas').textContent = estadisticas.total || 0;
        document.getElementById('empresasActivas').textContent = estadisticas.activas || 0;
        document.getElementById('empresasInactivas').textContent = estadisticas.inactivas || 0;
        document.getElementById('empresasSuspendidas').textContent = estadisticas.suspendidas || 0;
    }

    actualizarPaginacion(paginacion = {}) {
        if (paginacion) {
            this.totalPaginas = paginacion.total_paginas || this.totalPaginas;
            this.totalRegistros = paginacion.total_registros ?? this.totalRegistros;
            this.registrosPorPagina = paginacion.limite || this.registrosPorPagina;
        }

        const btnAnterior = document.getElementById('btnAnterior');
        const btnSiguiente = document.getElementById('btnSiguiente');
        const paginationNumbers = document.getElementById('paginationNumbers');

        const totalPaginas = Math.max(1, this.totalPaginas || 1);
        const noRegistros = this.totalRegistros === 0;

        btnAnterior.disabled = this.paginaActual <= 1 || noRegistros;
        btnSiguiente.disabled = this.paginaActual >= totalPaginas || noRegistros;

        const desde = noRegistros ? 0 : ((this.paginaActual - 1) * this.registrosPorPagina) + 1;
        const hasta = noRegistros ? 0 : Math.min(this.paginaActual * this.registrosPorPagina, this.totalRegistros);
        document.getElementById('mostrandoDesde').textContent = desde;
        document.getElementById('mostrandoHasta').textContent = hasta;
        document.getElementById('totalRegistros').textContent = this.totalRegistros;

        let paginasHTML = '';
        for (let i = 1; i <= totalPaginas; i++) {
            paginasHTML += `
                <button class="page-number ${i === this.paginaActual ? 'active' : ''}" 
                        onclick="companiesApp.irAPagina(${i})">
                    ${i}
                </button>
            `;
        }
        paginationNumbers.innerHTML = paginasHTML;
    }

    irAPagina(pagina) {
        if (pagina === this.paginaActual || pagina < 1 || pagina > this.totalPaginas) {
            return;
        }
        this.paginaActual = pagina;
        this.cargarEmpresas();
    }

    aplicarFiltros() {
        this.paginaActual = 1;
        this.cargarEmpresas();
    }

    // Modal Nueva Empresa
    mostrarModalNuevaEmpresa() {
        this.limpiarFormulario();
        document.getElementById('modalNuevaEmpresa').style.display = 'block';
    }

    cerrarModal() {
        document.getElementById('modalNuevaEmpresa').style.display = 'none';
    }

    async crearEmpresa() {
        try {
            const formData = this.obtenerDatosFormulario();

            if (!this.validarFormulario(formData)) {
                return;
            }

            const response = await fetch('/api/empresas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error('Error creando empresa');

            const result = await response.json();
            this.mostrarExito('Empresa creada exitosamente');
            this.cerrarModal();
            this.cargarEmpresas();

        } catch (error) {
            console.error('Error creando empresa:', error);
            this.mostrarError('Error al crear la empresa');
        }
    }

    obtenerDatosFormulario() {
        return {
            nombre: document.getElementById('nombreEmpresa').value,
            telefono: document.getElementById('telefonoEmpresa').value,
            email: document.getElementById('emailEmpresa').value,
            direccion: document.getElementById('direccionEmpresa').value,
            id_estado_empresa: parseInt(document.getElementById('estadoEmpresa').value)
        };
    }

    validarFormulario(formData) {
        if (!formData.nombre || formData.nombre.trim() === '') {
            this.mostrarError('Por favor ingrese el nombre de la empresa');
            return false;
        }

        if (!formData.id_estado_empresa) {
            this.mostrarError('Por favor seleccione un estado para la empresa');
            return false;
        }

        return true;
    }

    limpiarFormulario() {
        document.getElementById('formNuevaEmpresa').reset();
    }

    // Otras funcionalidades
    async verDetalles(idEmpresa) {
        try {
            const response = await fetch(`/api/empresas/${idEmpresa}`);
            if (!response.ok) throw new Error('Error cargando detalles');

            const empresa = await response.json();
            this.mostrarModalDetalles(empresa);

        } catch (error) {
            console.error('Error cargando detalles:', error);
            this.mostrarError('Error cargando detalles de la empresa');
        }
    }

    mostrarModalDetalles(empresa) {
        const content = document.getElementById('detallesEmpresaContent');
        content.innerHTML = this.generarHTMLDetalles(empresa);
        document.getElementById('modalDetallesEmpresa').style.display = 'block';
    }

    cerrarModalDetalles() {
        document.getElementById('modalDetallesEmpresa').style.display = 'none';
    }

    generarHTMLDetalles(empresa) {
        return `
            <div class="detalles-empresa">
                <div class="detalles-header">
                    <h4>Empresa #${empresa.id_empresa}</h4>
                    <span class="estado-badge estado-${this.obtenerEstadoClase(empresa.id_estado_empresa)}">
                        ${this.obtenerEstadoTexto(empresa.id_estado_empresa)}
                    </span>
                </div>
                
                <div class="detalles-info">
                    <div class="info-group">
                        <h5>Información de la Empresa</h5>
                        <p><strong>Nombre:</strong> ${empresa.nombre || 'N/A'}</p>
                        <p><strong>Email:</strong> ${empresa.email || 'No especificado'}</p>
                        <p><strong>Teléfono:</strong> ${empresa.telefono || 'No especificado'}</p>
                        <p><strong>Fecha de Registro:</strong> ${this.formatearFecha(empresa.fecha_creacion)}</p>
                        <p><strong>Última Actualización:</strong> ${this.formatearFecha(empresa.fecha_actualizacion)}</p>
                    </div>
                    
                    ${empresa.direccion ? `
                        <div class="info-group">
                            <h5>Dirección</h5>
                            <div class="direccion-completa">
                                ${empresa.direccion}
                            </div>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    async editarEmpresa(idEmpresa) {
        // Implementar edición de empresa
        this.mostrarExito(`Editar empresa ${idEmpresa} - Funcionalidad en desarrollo`);
    }

    async eliminarEmpresa(idEmpresa) {
        if (!confirm('¿Está seguro de que desea eliminar esta empresa? Esta acción no se puede deshacer.')) {
            return;
        }

        try {
            const response = await fetch(`/api/empresas/${idEmpresa}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Error eliminando empresa');

            this.mostrarExito('Empresa eliminada exitosamente');
            this.cargarEmpresas();

        } catch (error) {
            console.error('Error eliminando empresa:', error);
            this.mostrarError('Error al eliminar la empresa');
        }
    }

    // Utilidades
    formatearFecha(fechaString) {
        if (!fechaString) return 'N/A';
        const fecha = new Date(fechaString);
        return fecha.toLocaleDateString('es-ES', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaEmpresas');
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center">
                    <div class="loading-spinner">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Cargando empresas...</span>
                    </div>
                </td>
            </tr>
        `;
    }

    mostrarError(mensaje) {
        // Implementar sistema de notificaciones
        alert(`Error: ${mensaje}`);
    }

    mostrarExito(mensaje) {
        // Implementar sistema de notificaciones
        alert(`Éxito: ${mensaje}`);
    }
}

// Inicializar la aplicación de empresas
document.addEventListener('DOMContentLoaded', () => {
    window.companiesApp = new CompaniesApp();
});