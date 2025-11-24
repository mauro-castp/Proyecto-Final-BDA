class ClientsApp {
    constructor() {
        this.clientes = [];
        this.estadosCliente = [];
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.totalRegistros = 0;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            busqueda: ''
        };
        this.contadorDirecciones = 0;
        this.init();
    }

    init() {
        this.bindEvents();
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
                ...this.filtros
            });

            const response = await fetch(`/api/clientes?${params}`);
            if (!response.ok) throw new Error('Error cargando clientes');

            const data = await response.json();
            this.clientes = data.clientes || [];
            this.totalPaginas = data.paginacion?.total_paginas || 1;
            this.totalRegistros = data.paginacion?.total_registros ?? this.clientes.length;
            this.registrosPorPagina = data.paginacion?.limite || this.registrosPorPagina;

            this.actualizarTabla();
            this.actualizarEstadisticas(data.estadisticas || {});
            this.actualizarPaginacion(data.paginacion);

        } catch (error) {
            console.error('Error cargando clientes:', error);
            this.mostrarError('Error cargando la lista de clientes');
        }
    }

    actualizarTabla() {
        const tbody = document.getElementById('tablaClientes');

        if (this.clientes.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center">
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
                    <span class="estado-badge estado-${this.obtenerEstadoClase(cliente.id_estado_cliente)}">
                        ${this.obtenerEstadoTexto(cliente.id_estado_cliente)}
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

    obtenerEstadoTexto(idEstado) {
        const estados = {
            1: 'Activo',
            2: 'Inactivo',
            3: 'Bloqueado'
        };
        return estados[idEstado] || 'Inactivo';
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
        this.agregarDireccion(); // Agregar una dirección por defecto
        document.getElementById('modalNuevoCliente').style.display = 'block';
    }

    cerrarModal() {
        document.getElementById('modalNuevoCliente').style.display = 'none';
    }

    agregarDireccion() {
        const lista = document.getElementById('listaDirecciones');
        const plantilla = document.getElementById('direccionPlantilla');
        const nuevaDireccion = plantilla.cloneNode(true);

        this.contadorDirecciones++;
        nuevaDireccion.style.display = 'block';
        nuevaDireccion.id = '';
        nuevaDireccion.querySelector('.direccion-numero').textContent = this.contadorDirecciones;

        lista.appendChild(nuevaDireccion);
    }

    eliminarDireccion(boton) {
        const direccionItem = boton.closest('.direccion-item');
        if (document.querySelectorAll('.direccion-item').length > 1) {
            direccionItem.remove();
            this.renumerarDirecciones();
        } else {
            this.mostrarError('Debe haber al menos una dirección');
        }
    }

    renumerarDirecciones() {
        const direcciones = document.querySelectorAll('.direccion-item');
        direcciones.forEach((direccion, index) => {
            direccion.querySelector('.direccion-numero').textContent = index + 1;
        });
        this.contadorDirecciones = direcciones.length;
    }

    async crearCliente() {
        try {
            const formData = this.obtenerDatosFormulario();

            if (!this.validarFormulario(formData)) {
                return;
            }

            const response = await fetch('/api/clientes', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error('Error creando cliente');

            const result = await response.json();
            this.mostrarExito('Cliente creado exitosamente');
            this.cerrarModal();
            this.cargarClientes();

        } catch (error) {
            console.error('Error creando cliente:', error);
            this.mostrarError('Error al crear el cliente');
        }
    }

    obtenerDatosFormulario() {
        const direcciones = [];

        document.querySelectorAll('.direccion-item').forEach(item => {
            const direccion = {
                direccion: item.querySelector('.direccion-campo').value,
                ciudad: item.querySelector('.ciudad-campo').value,
                codigo_postal: item.querySelector('.codigo-postal-campo').value,
                provincia: item.querySelector('.provincia-campo').value,
                pais: item.querySelector('.pais-campo').value,
                es_principal: item.querySelector('.direccion-principal').checked
            };

            if (direccion.direccion && direccion.ciudad) {
                direcciones.push(direccion);
            }
        });

        return {
            nombre: document.getElementById('nombreCliente').value,
            telefono: document.getElementById('telefonoCliente').value,
            email: document.getElementById('emailCliente').value,
            id_estado_cliente: parseInt(document.getElementById('estadoCliente').value),
            direcciones: direcciones
        };
    }

    validarFormulario(formData) {
        if (!formData.nombre || formData.nombre.trim() === '') {
            this.mostrarError('Por favor ingrese el nombre del cliente');
            return false;
        }

        if (!formData.id_estado_cliente) {
            this.mostrarError('Por favor seleccione un estado para el cliente');
            return false;
        }

        if (!Array.isArray(formData.direcciones) || formData.direcciones.length === 0) {
            this.mostrarError('Por favor agregue al menos una dirección válida');
            return false;
        }

        // Validar que al menos una dirección esté marcada como principal
        const direccionesPrincipales = formData.direcciones.filter(dir => dir.es_principal);
        if (direccionesPrincipales.length === 0 && formData.direcciones.length > 0) {
            formData.direcciones[0].es_principal = true;
        }

        return true;
    }

    limpiarFormulario() {
        document.getElementById('formNuevoCliente').reset();
        document.getElementById('listaDirecciones').innerHTML = '';
        this.contadorDirecciones = 0;
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
                        ${this.obtenerEstadoTexto(cliente.id_estado_cliente)}
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
                    
                    ${cliente.direcciones && cliente.direcciones.length > 0 ? `
                        <div class="info-group">
                            <h5>Direcciones</h5>
                            <div class="direcciones-lista">
                                ${cliente.direcciones.map(direccion => `
                                    <div class="direccion-detalle ${direccion.es_principal ? 'direccion-principal' : ''}">
                                        <div class="direccion-header">
                                            <strong>${direccion.direccion}</strong>
                                            ${direccion.es_principal ? '<span class="badge-principal">Principal</span>' : ''}
                                        </div>
                                        <div class="direccion-info">
                                            <span>${direccion.ciudad}</span>
                                            ${direccion.codigo_postal ? `<span>CP: ${direccion.codigo_postal}</span>` : ''}
                                            ${direccion.provincia ? `<span>${direccion.provincia}</span>` : ''}
                                            ${direccion.pais ? `<span>${direccion.pais}</span>` : ''}
                                        </div>
                                    </div>
                                `).join('')}
                            </div>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;
    }

    async editarCliente(idCliente) {
        // Implementar edición de cliente
        this.mostrarExito(`Editar cliente ${idCliente} - Funcionalidad en desarrollo`);
    }

    async eliminarCliente(idCliente) {
        if (!confirm('¿Está seguro de que desea eliminar este cliente? Esta acción no se puede deshacer.')) {
            return;
        }

        try {
            const response = await fetch(`/api/clientes/${idCliente}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Error eliminando cliente');

            this.mostrarExito('Cliente eliminado exitosamente');
            this.cargarClientes();

        } catch (error) {
            console.error('Error eliminando cliente:', error);
            this.mostrarError('Error al eliminar el cliente');
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
        const tbody = document.getElementById('tablaClientes');
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="text-center">
                    <div class="loading-spinner">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Cargando clientes...</span>
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

// Inicializar la aplicación de clientes
document.addEventListener('DOMContentLoaded', () => {
    window.clientsApp = new ClientsApp();
});