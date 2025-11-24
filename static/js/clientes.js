class ClientsApp {
    constructor() {
        this.clientes = [];
        this.zonas = [];
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

    async init() {
        this.bindEvents();
        this.cargarZonas();
        this.cargarClientes();
    }

    bindEvents() {
        // Filtros
        document.getElementById('filtroEstado').addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
        });

        document.getElementById('filtroBusqueda').addEventListener('input', (e) => {
            this.filtros.busqueda = e.target.value;
        });

        // Enter en búsqueda
        document.getElementById('filtroBusqueda').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.aplicarFiltros();
            }
        });

        // Paginación
        document.getElementById('btnAnterior').addEventListener('click', () => {
            if (this.paginaActual > 1) {
                this.paginaActual--;
                this.cargarClientes();
            }
        });

        document.getElementById('btnSiguiente').addEventListener('click', () => {
            if (this.paginaActual < this.totalPaginas) {
                this.paginaActual++;
                this.cargarClientes();
            }
        });
    }

    async cargarClientes() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                estado: this.filtros.estado,
                busqueda: this.filtros.busqueda
            });

            const response = await fetch(`/api/clientes?${params}`);
            if (!response.ok) throw new Error('Error cargando clientes');

            const data = await response.json();
            this.clientes = data.clientes || [];
            this.totalPaginas = data.paginacion?.total_paginas || 1;
            this.totalRegistros = data.paginacion?.total_registros || 0;
            this.registrosPorPagina = data.paginacion?.limite || this.registrosPorPagina;

            this.actualizarTabla();
            this.actualizarEstadisticas(data.estadisticas || {});
            this.actualizarPaginacion(data.paginacion);

            this.cerrarCargando();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error cargando clientes:', error);
            this.mostrarError('Error cargando la lista de clientes');
        }
    }

    async cargarZonas() {
        try {
            const response = await fetch('/api/zonas');
            if (!response.ok) throw new Error('Error cargando zonas');
            this.zonas = await response.json();

            // Cargar zonas en los selects inmediatamente
            this.cargarZonasEnSelects();

        } catch (error) {
            console.error('Error cargando zonas:', error);
        }
    }

    cargarZonasEnSelects() {
        const selectNuevo = document.getElementById('zonaCliente');
        const selectEditar = document.getElementById('editarZonaCliente');

        if (this.zonas.length > 0) {
            const zonasOptions = '<option value="">Seleccionar zona...</option>' +
                this.zonas.map(zona =>
                    `<option value="${zona.id_zona}">${zona.nombre_zona}</option>`
                ).join('');

            if (selectNuevo) {
                selectNuevo.innerHTML = zonasOptions;
            }

            if (selectEditar) {
                selectEditar.innerHTML = zonasOptions;
            }
        }
    }

    actualizarTabla() {
        const tbody = document.getElementById('tablaClientes');

        if (this.clientes.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-users"></i>
                            <span>No se encontraron clientes</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.clientes.map(cliente => `
            <tr>
                <td>
                    <div class="cliente-info">
                        <strong>${cliente.nombre || 'N/A'}</strong>
                    </div>
                </td>
                <td>${cliente.telefono || 'No especificado'}</td>
                <td>${cliente.email || 'No especificado'}</td>
                <td>
                    <div class="direccion-truncada" title="${cliente.direccion || ''}">
                        ${cliente.direccion ? this.truncarTexto(cliente.direccion, 50) : 'No especificada'}
                    </div>
                </td>
                <td>${cliente.nombre_zona || 'No asignada'}</td>
                <td>
                    <span class="estado-badge estado-${this.obtenerEstadoClase(cliente.id_estado_cliente)}">
                        ${cliente.estado_nombre || 'Inactivo'}
                    </span>
                </td>
                <td>${this.formatearFecha(cliente.fecha_creacion)}</td>
                <td class="acciones-cell">
                    <button class="btn-action btn-view" onclick="clientsApp.verDetalles(${cliente.id_cliente})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn-action btn-edit" onclick="clientsApp.editarCliente(${cliente.id_cliente})" title="Editar">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-action btn-delete" onclick="clientsApp.eliminarCliente(${cliente.id_cliente})" title="Eliminar">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `).join('');
    }

    obtenerEstadoClase(idEstado) {
        const estados = {
            1: 'activo',
            2: 'inactivo',
            3: 'bloqueado'
        };
        return estados[idEstado] || 'inactivo';
    }

    truncarTexto(texto, longitud) {
        if (!texto) return '';
        if (texto.length <= longitud) return texto;
        return texto.substring(0, longitud) + '...';
    }

    actualizarEstadisticas(estadisticas = {}) {
        document.getElementById('totalClientes').textContent = estadisticas.total || 0;
        document.getElementById('clientesActivos').textContent = estadisticas.activos || 0;
        document.getElementById('clientesInactivos').textContent = estadisticas.inactivos || 0;
        document.getElementById('clientesBloqueados').textContent = estadisticas.bloqueados || 0;
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
                        onclick="clientsApp.irAPagina(${i})">
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
        this.cargarClientes();
    }

    aplicarFiltros() {
        this.paginaActual = 1;
        this.cargarClientes();
    }

    // Modal Nuevo Cliente
    mostrarModalNuevoCliente() {
        this.limpiarFormulario();
        this.cargarZonasModal(); // Asegurar que las zonas estén cargadas
        document.getElementById('modalNuevoCliente').style.display = 'block';
    }

    cerrarModal() {
        document.getElementById('modalNuevoCliente').style.display = 'none';
    }

    async cargarZonasModal() {
        try {
            // Si ya tenemos las zonas cargadas, usarlas
            if (this.zonas.length === 0) {
                const response = await fetch('/api/zonas');
                if (!response.ok) throw new Error('Error cargando zonas');
                this.zonas = await response.json();
            }

            const selectNuevo = document.getElementById('zonaCliente');
            const selectEditar = document.getElementById('editarZonaCliente');

            const zonasOptions = '<option value="">Seleccionar zona...</option>' +
                this.zonas.map(zona =>
                    `<option value="${zona.id_zona}">${zona.nombre_zona}</option>`
                ).join('');

            if (selectNuevo) {
                selectNuevo.innerHTML = zonasOptions;
            }

            if (selectEditar) {
                selectEditar.innerHTML = zonasOptions;
            }

        } catch (error) {
            console.error('Error cargando zonas para modal:', error);
            // No mostrar error al usuario para no interrumpir el flujo
        }
    }

    async crearCliente() {
        try {
            const formData = this.obtenerDatosFormulario();

            if (!this.validarFormulario(formData)) {
                return;
            }

            // Mostrar carga
            this.mostrarCargando('Creando cliente...');

            const response = await fetch('/api/clientes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error creando cliente');
            }

            this.cerrarCargando();
            this.mostrarExito('Cliente creado exitosamente');
            this.cerrarModal();
            this.cargarClientes();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error creando cliente:', error);
            this.mostrarError(error.message || 'Error al crear el cliente');
        }
    }

    obtenerDatosFormulario() {
        return {
            nombre: document.getElementById('nombreCliente').value.trim(),
            telefono: document.getElementById('telefonoCliente').value.trim(),
            email: document.getElementById('emailCliente').value.trim(),
            direccion: document.getElementById('direccionCliente').value.trim(),
            id_zona: parseInt(document.getElementById('zonaCliente').value),
            id_estado_cliente: parseInt(document.getElementById('estadoCliente').value)
        };
    }

    validarFormulario(formData) {
        if (!formData.nombre || formData.nombre.trim() === '') {
            this.mostrarError('Por favor ingrese el nombre del cliente');
            return false;
        }

        if (!formData.id_zona || isNaN(formData.id_zona)) {
            this.mostrarError('Por favor seleccione una zona válida');
            return false;
        }

        if (!formData.direccion || formData.direccion.trim() === '') {
            this.mostrarError('Por favor ingrese la dirección del cliente');
            return false;
        }

        if (!formData.id_estado_cliente || isNaN(formData.id_estado_cliente)) {
            this.mostrarError('Por favor seleccione un estado válido para el cliente');
            return false;
        }

        // Validar email si se proporciona
        if (formData.email && formData.email.trim() !== '' && !this.validarEmail(formData.email)) {
            this.mostrarError('Por favor ingrese un email válido');
            return false;
        }

        return true;
    }

    validarEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    limpiarFormulario() {
        document.getElementById('formNuevoCliente').reset();
    }

    // Otras funcionalidades
    async verDetalles(idCliente) {
        try {
            const response = await fetch(`/api/clientes/${idCliente}`);
            if (!response.ok) throw new Error('Error cargando detalles');

            const cliente = await response.json();
            this.mostrarModalDetalles(cliente);

        } catch (error) {
            console.error('Error cargando detalles:', error);
            this.mostrarError('Error cargando detalles del cliente');
        }
    }

    mostrarModalDetalles(cliente) {
        const content = document.getElementById('detallesClienteContent');
        content.innerHTML = this.generarHTMLDetalles(cliente);
        document.getElementById('modalDetallesCliente').style.display = 'block';
    }

    cerrarModalDetalles() {
        document.getElementById('modalDetallesCliente').style.display = 'none';
    }

    generarHTMLDetalles(cliente) {
        return `
            <div class="detalles-cliente">
                <div class="detalles-header">
                    <h4>Cliente #${cliente.id_cliente}</h4>
                    <span class="estado-badge estado-${this.obtenerEstadoClase(cliente.id_estado_cliente)}">
                        ${cliente.estado_nombre || 'Inactivo'}
                    </span>
                </div>
                
                <div class="detalles-info">
                    <div class="info-group">
                        <h5>Información Personal</h5>
                        <p><strong>Nombre:</strong> ${cliente.nombre || 'N/A'}</p>
                        <p><strong>Email:</strong> ${cliente.email || 'No especificado'}</p>
                        <p><strong>Teléfono:</strong> ${cliente.telefono || 'No especificado'}</p>
                        <p><strong>Fecha de Registro:</strong> ${this.formatearFecha(cliente.fecha_creacion)}</p>
                        <p><strong>Última Actualización:</strong> ${this.formatearFecha(cliente.fecha_actualizacion)}</p>
                    </div>
                    
                    ${cliente.direccion ? `
                        <div class="info-group">
                            <h5>Dirección Principal</h5>
                            <div class="direccion-completa">
                                <p><strong>Dirección:</strong> ${cliente.direccion}</p>
                                ${cliente.nombre_zona ? `<p><strong>Zona:</strong> ${cliente.nombre_zona}</p>` : ''}
                            </div>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    async editarCliente(idCliente) {
        try {
            // Cargar zonas antes de abrir el modal
            await this.cargarZonasModal();

            const response = await fetch(`/api/clientes/${idCliente}`);
            if (!response.ok) throw new Error('Error cargando datos del cliente');

            const cliente = await response.json();
            this.mostrarModalEditar(cliente);

        } catch (error) {
            console.error('Error cargando datos del cliente:', error);
            this.mostrarError('Error cargando datos del cliente para editar');
        }
    }

    mostrarModalEditar(cliente) {
        // Establecer los valores del formulario
        document.getElementById('editarIdCliente').value = cliente.id_cliente;
        document.getElementById('editarNombreCliente').value = cliente.nombre || '';
        document.getElementById('editarTelefonoCliente').value = cliente.telefono || '';
        document.getElementById('editarEmailCliente').value = cliente.email || '';
        document.getElementById('editarDireccionCliente').value = cliente.direccion || '';
        document.getElementById('editarEstadoCliente').value = cliente.id_estado_cliente || 1;

        // Establecer la zona - IMPORTANTE: hacer después de cargar las opciones
        const selectZona = document.getElementById('editarZonaCliente');
        if (selectZona && cliente.id_zona) {
            // Esperar un momento para asegurar que las opciones estén cargadas
            setTimeout(() => {
                selectZona.value = cliente.id_zona;
            }, 100);
        } else if (selectZona) {
            selectZona.value = '';
        }

        // Mostrar el modal
        document.getElementById('modalEditarCliente').style.display = 'block';
    }

    cerrarModalEditar() {
        document.getElementById('modalEditarCliente').style.display = 'none';
    }

    async actualizarCliente() {
        try {
            const formData = this.obtenerDatosFormularioEditar();

            if (!this.validarFormularioEditar(formData)) {
                return;
            }

            const idCliente = document.getElementById('editarIdCliente').value;

            // Mostrar carga
            this.mostrarCargando('Actualizando cliente...');

            const response = await fetch(`/api/clientes/${idCliente}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error actualizando cliente');
            }

            this.cerrarCargando();
            this.mostrarExito('Cliente actualizado exitosamente');
            this.cerrarModalEditar();
            this.cargarClientes();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error actualizando cliente:', error);
            this.mostrarError(error.message || 'Error al actualizar el cliente');
        }
    }

    obtenerDatosFormularioEditar() {
        return {
            nombre: document.getElementById('editarNombreCliente').value.trim(),
            telefono: document.getElementById('editarTelefonoCliente').value.trim(),
            email: document.getElementById('editarEmailCliente').value.trim(),
            direccion: document.getElementById('editarDireccionCliente').value.trim(),
            id_zona: parseInt(document.getElementById('editarZonaCliente').value),
            id_estado_cliente: parseInt(document.getElementById('editarEstadoCliente').value)
        };
    }

    validarFormularioEditar(formData) {
        return this.validarFormulario(formData);
    }

    async eliminarCliente(idCliente) {
        try {
            const result = await this.mostrarConfirmacion(
                '¿Está seguro de que desea eliminar este cliente? Esta acción no se puede deshacer.',
                'Sí, eliminar',
                'Cancelar'
            );

            if (!result.isConfirmed) {
                return;
            }

            // Mostrar carga
            this.mostrarCargando('Eliminando cliente...');

            const response = await fetch(`/api/clientes/${idCliente}`, {
                method: 'DELETE'
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Error eliminando cliente');
            }

            this.cerrarCargando();
            this.mostrarExito(data.message || 'Cliente eliminado exitosamente');
            this.cargarClientes();

        } catch (error) {
            this.cerrarCargando();
            console.error('Error eliminando cliente:', error);
            this.mostrarError(error.message || 'Error al eliminar el cliente');
        }
    }

    // Utilidades
    formatearFecha(fechaString) {
        if (!fechaString) return 'N/A';
        try {
            const fecha = new Date(fechaString);
            return fecha.toLocaleDateString('es-ES', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
        } catch (error) {
            return 'Fecha inválida';
        }
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaClientes');
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center">
                    <div class="loading-spinner">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Cargando clientes...</span>
                    </div>
                </td>
            </tr>
        `;
    }

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
}

// Inicializar la aplicación de clientes
document.addEventListener('DOMContentLoaded', () => {
    window.clientsApp = new ClientsApp();
});