// static/js/pedidos.js - VERSIÓN SIMPLIFICADA Y CORREGIDA
class PedidosApp {
    constructor() {
        this.pedidos = [];
        this.clientes = [];
        this.productos = [];
        this.empresas = [];
        this.estadosPedido = [];
        this.pedidoEditando = null;
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.totalRegistros = 0;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            fecha: '',
            empresa: ''
        };
        this.init();
    }

    init() {
        this.bindEvents();
        this.cargarDatosIniciales();
        this.cargarPedidos();
    }

    bindEvents() {
        // Filtros
        document.getElementById('filtroEstado').addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
            this.aplicarFiltros();
        });

        document.getElementById('filtroFecha').addEventListener('change', (e) => {
            this.filtros.fecha = e.target.value;
            this.aplicarFiltros();
        });

        document.getElementById('filtroEmpresa').addEventListener('change', (e) => {
            this.filtros.empresa = e.target.value;
            this.aplicarFiltros();
        });

        // Paginación
        document.getElementById('btnAnterior').addEventListener('click', () => {
            if (this.paginaActual > 1) {
                this.paginaActual--;
                this.cargarPedidos();
            }
        });

        document.getElementById('btnSiguiente').addEventListener('click', () => {
            if (this.paginaActual < this.totalPaginas) {
                this.paginaActual++;
                this.cargarPedidos();
            }
        });

        // Cerrar modales al hacer clic fuera
        window.onclick = (event) => {
            const modalNuevo = document.getElementById('modalNuevoPedido');
            const modalDetalles = document.getElementById('modalDetallesPedido');
            const modalEditar = document.getElementById('modalEditarPedido');
            
            if (event.target === modalNuevo) {
                this.cerrarModal();
            }
            if (event.target === modalDetalles) {
                this.cerrarModalDetalles();
            }
            if (event.target === modalEditar) {
                this.cerrarModalEditar();
            }
        };
    }

    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarClientes(),
                this.cargarProductos(),
                this.cargarEmpresas(),
                this.cargarEmpresasFiltro(),
                this.cargarEstadosPedido()
            ]);
        } catch (error) {
            console.error('Error cargando datos iniciales:', error);
            this.mostrarError('Error cargando datos del sistema');
        }
    }

    async cargarPedidos() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                ...this.filtros
            });

            const response = await fetch(`/api/pedidos?${params}`);
            if (!response.ok) throw new Error('Error cargando pedidos');

            const data = await response.json();
            this.pedidos = data.pedidos || [];
            this.totalPaginas = data.paginacion?.total_paginas || 1;
            this.totalRegistros = data.paginacion?.total_registros ?? this.pedidos.length;
            this.registrosPorPagina = data.paginacion?.limite || this.registrosPorPagina;

            this.actualizarTabla();
            this.actualizarEstadisticas(data.estadisticas || {});
            this.actualizarPaginacion(data.paginacion);

        } catch (error) {
            console.error('Error cargando pedidos:', error);
            this.mostrarError('Error cargando la lista de pedidos');
        }
    }

    async cargarClientes() {
        const response = await fetch('/api/pedidos/clientes-activos');
        if (!response.ok) throw new Error('Error cargando clientes');
        this.clientes = await response.json();
    }

    async cargarProductos() {
        const response = await fetch('/api/pedidos/productos-activos');
        if (!response.ok) throw new Error('Error cargando productos');
        this.productos = await response.json();
    }

    async cargarEmpresas() {
        const response = await fetch('/api/pedidos/empresas-activas');
        if (!response.ok) throw new Error('Error cargando empresas');
        this.empresas = await response.json();
    }

    async cargarEstadosPedido() {
        try {
            const response = await fetch('/api/pedidos/estados');
            if (!response.ok) throw new Error('Error cargando estados');
            this.estadosPedido = await response.json();
        } catch (error) {
            console.error('Error cargando estados de pedido:', error);
            this.estadosPedido = [];
        }
    }

    async cargarEmpresasFiltro() {
        const select = document.getElementById('filtroEmpresa');
        if (!select) return;

        try {
            const response = await fetch('/api/pedidos/empresas-activas');
            if (!response.ok) throw new Error('Error cargando empresas');
            const empresas = await response.json();

            select.innerHTML = '<option value="">Todas las empresas</option>' +
                empresas.map(empresa => 
                    `<option value="${empresa.id_empresa}">${empresa.nombre}</option>`
                ).join('');
        } catch (error) {
            console.error('Error cargando empresas para filtro:', error);
        }
    }

    async cargarDireccionesCliente(clienteId) {
        const select = document.getElementById('direccionPedido');
        if (!select) return;

        select.innerHTML = '<option value="">Seleccionar dirección...</option>';
        select.disabled = true;

        if (!clienteId) return;

        try {
            const response = await fetch(`/api/pedidos/cliente/${clienteId}/direcciones`);
            if (!response.ok) throw new Error('Error cargando direcciones');
            const direcciones = await response.json();

            if (direcciones.length === 0) {
                select.innerHTML += '<option value="" disabled>Sin direcciones registradas</option>';
            } else {
                select.innerHTML += direcciones.map(dir => `
                    <option value="${dir.id_direccion}">
                        ${dir.direccion}${dir.es_principal ? ' (Principal)' : ''}
                    </option>
                `).join('');
            }
            select.disabled = false;
        } catch (error) {
            console.error('Error cargando direcciones:', error);
            this.mostrarError('No se pudieron cargar las direcciones del cliente');
            select.disabled = false;
        }
    }

    actualizarTabla() {
        const tbody = document.getElementById('tablaPedidos');

        if (this.pedidos.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-inbox"></i>
                            <span>No se encontraron pedidos</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.pedidos.map(pedido => `
            <tr>
                <td><strong>#${pedido.id_pedido}</strong></td>
                <td>${pedido.cliente_nombre || 'N/A'}</td>
                <td>${pedido.empresa_nombre || 'Sin empresa'}</td>
                <td>${this.formatearFecha(pedido.fecha_pedido)}</td>
                <td>$${this.formatearPrecio(pedido.total_pedido || 0)}</td>
                <td>${pedido.cantidad_productos || 0} productos</td>
                <td>
                    <span class="estado-badge estado-${(pedido.estado_nombre || 'pendiente').toLowerCase().replace(/\s+/g, '-')}">
                        ${pedido.estado_nombre || 'Pendiente'}
                    </span>
                </td>
                <td class="acciones-cell">
                    <button class="btn-action btn-view" onclick="pedidosApp.verDetalles(${pedido.id_pedido})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${this.puedeEditar(pedido) ? `
                        <button class="btn-action btn-edit" onclick="pedidosApp.editarPedido(${pedido.id_pedido})" title="Actualizar estado">
                            <i class="fas fa-edit"></i>
                        </button>
                    ` : ''}
                    ${this.puedeCancelar(pedido) ? `
                        <button class="btn-action btn-cancel" onclick="pedidosApp.cancelarPedido(${pedido.id_pedido})" title="Cancelar">
                            <i class="fas fa-times"></i>
                        </button>
                    ` : ''}
                    ${this.puedeEliminar(pedido) ? `
                        <button class="btn-action btn-delete" onclick="pedidosApp.eliminarPedido(${pedido.id_pedido})" title="Eliminar">
                            <i class="fas fa-trash"></i>
                        </button>
                    ` : ''}
                </td>
            </tr>
        `).join('');
    }

    puedeEditar(pedido) {
        const estado = pedido.estado_nombre?.toLowerCase();
        const estadosEditables = ['pendiente', 'confirmado', 'en preparacion', 'listo para entrega', 'en camino'];
        return estadosEditables.includes(estado);
    }

    puedeCancelar(pedido) {
        const estado = pedido.estado_nombre?.toLowerCase();
        const estadosCancelables = ['pendiente', 'confirmado', 'en preparacion'];
        return estadosCancelables.includes(estado);
    }

    puedeEliminar(pedido) {
        const estado = pedido.estado_nombre?.toLowerCase();
        return estado === 'pendiente';
    }

    actualizarEstadisticas(estadisticas = {}) {
        document.getElementById('totalPedidos').textContent = estadisticas.total || 0;
        document.getElementById('pedidosPendientes').textContent = estadisticas.pendientes || 0;
        document.getElementById('pedidosProceso').textContent = estadisticas.proceso || 0;
        document.getElementById('pedidosCompletados').textContent = estadisticas.completados || 0;
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
        const paginasVisibles = 5;
        let inicioPagina = Math.max(1, this.paginaActual - Math.floor(paginasVisibles / 2));
        let finPagina = Math.min(totalPaginas, inicioPagina + paginasVisibles - 1);

        for (let i = inicioPagina; i <= finPagina; i++) {
            paginasHTML += `
                <button class="page-number ${i === this.paginaActual ? 'active' : ''}" 
                        onclick="pedidosApp.irAPagina(${i})">
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
        this.cargarPedidos();
    }

    aplicarFiltros() {
        this.paginaActual = 1;
        this.cargarPedidos();
    }

    // ==================== CRUD OPERATIONS ====================

    mostrarModalNuevoPedido() {
        this.pedidoEditando = null;
        document.getElementById('modalPedidoTitulo').innerHTML = '<i class="fas fa-plus-circle"></i> Nuevo Pedido';
        this.limpiarFormulario();
        this.cargarClientesModal();
        this.cargarEmpresasModal();
        this.cargarProductosModal();
        document.getElementById('modalNuevoPedido').style.display = 'block';
    }

    cerrarModal() {
        document.getElementById('modalNuevoPedido').style.display = 'none';
        this.pedidoEditando = null;
    }

    cargarClientesModal() {
        const select = document.getElementById('clientePedido');
        select.innerHTML = '<option value="">Seleccionar cliente...</option>' +
            this.clientes.map(cliente =>
                `<option value="${cliente.id_cliente}">${cliente.nombre}</option>`
            ).join('');
    }

    cargarEmpresasModal() {
        const select = document.getElementById('empresaPedido');
        select.innerHTML = '<option value="">Sin empresa</option>' +
            this.empresas.map(empresa =>
                `<option value="${empresa.id_empresa}">${empresa.nombre}</option>`
            ).join('');
    }

    cargarProductosModal() {
        const lista = document.getElementById('listaProductos');
        lista.innerHTML = '';
        this.agregarProducto(); // Agregar un producto inicial
    }

    agregarProducto() {
        const lista = document.getElementById('listaProductos');
        const productoBase = document.getElementById('productoBase');
        const nuevoProducto = productoBase.cloneNode(true);

        nuevoProducto.style.display = 'block';
        nuevoProducto.id = '';
        
        // Cargar productos en el select
        const select = nuevoProducto.querySelector('.producto-select');
        select.innerHTML = '<option value="">Seleccionar producto...</option>' +
            this.productos.map(producto =>
                `<option value="${producto.id_producto}" data-precio="${producto.precio_unitario}">
                    ${producto.nombre} - $${this.formatearPrecio(producto.precio_unitario)}
                </option>`
            ).join('');

        lista.appendChild(nuevoProducto);
        this.actualizarTotal();
    }

    eliminarProducto(boton) {
        const productoItem = boton.closest('.producto-item');
        if (document.querySelectorAll('.producto-item').length > 1) {
            productoItem.remove();
            this.actualizarTotal();
        } else {
            this.mostrarError('El pedido debe tener al menos un producto');
        }
    }

    actualizarPrecio(select) {
        const productoItem = select.closest('.producto-item');
        const precioInput = productoItem.querySelector('.precio-input');
        const opcionSeleccionada = select.selectedOptions[0];

        if (opcionSeleccionada && opcionSeleccionada.value) {
            const precio = opcionSeleccionada.getAttribute('data-precio') || '0';
            precioInput.value = `$${this.formatearPrecio(precio)}`;
            this.actualizarSubtotal(select);
        } else {
            precioInput.value = '$0.00';
            productoItem.querySelector('.subtotal-input').value = '$0.00';
        }
    }

    actualizarSubtotal(elemento) {
        const productoItem = elemento.closest('.producto-item');
        const select = productoItem.querySelector('.producto-select');
        const cantidadInput = productoItem.querySelector('.cantidad-input');
        const subtotalInput = productoItem.querySelector('.subtotal-input');

        const precio = parseFloat(select.selectedOptions[0]?.getAttribute('data-precio') || 0);
        const cantidad = parseInt(cantidadInput.value) || 0;
        const subtotal = precio * cantidad;

        subtotalInput.value = `$${this.formatearPrecio(subtotal)}`;
        this.actualizarTotal();
    }

    actualizarTotal() {
        let total = 0;

        document.querySelectorAll('.producto-item').forEach(item => {
            if (item.style.display === 'none') return;
            
            const subtotalTexto = item.querySelector('.subtotal-input').value;
            total += parseFloat(subtotalTexto.replace('$', '')) || 0;
        });

        document.getElementById('totalPedido').value = `$${this.formatearPrecio(total)}`;
    }

    async guardarPedido() {
        try {
            const formData = this.obtenerDatosFormulario();

            if (!this.validarFormulario(formData)) {
                return;
            }

            const url = '/api/pedidos';
            const method = 'POST';

            const response = await fetch(url, {
                method: method,
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            const result = await response.json();
            
            if (!response.ok) {
                throw new Error(result.error || 'Error guardando pedido');
            }

            this.mostrarExito(result.message || 'Pedido creado exitosamente');
            this.cerrarModal();
            await this.cargarPedidos();

        } catch (error) {
            console.error('Error guardando pedido:', error);
            this.mostrarError(error.message || 'Error al guardar el pedido');
        }
    }

    obtenerDatosFormulario() {
        const productos = [];

        document.querySelectorAll('.producto-item').forEach(item => {
            if (item.style.display === 'none') return;

            const select = item.querySelector('.producto-select');
            const cantidadInput = item.querySelector('.cantidad-input');

            if (select.value && cantidadInput.value) {
                productos.push({
                    producto: parseInt(select.value),
                    cantidad: parseInt(cantidadInput.value)
                });
            }
        });

        return {
            id_cliente: parseInt(document.getElementById('clientePedido').value),
            id_direccion: parseInt(document.getElementById('direccionPedido').value),
            id_empresa: document.getElementById('empresaPedido').value ? 
                parseInt(document.getElementById('empresaPedido').value) : null,
            items: productos
        };
    }

    validarFormulario(formData) {
        if (!formData.id_cliente) {
            this.mostrarError('Por favor seleccione un cliente');
            return false;
        }

        if (!formData.id_direccion) {
            this.mostrarError('Por favor seleccione una dirección de entrega');
            return false;
        }

        if (!Array.isArray(formData.items) || formData.items.length === 0) {
            this.mostrarError('Por favor agregue al menos un producto');
            return false;
        }

        // Validar que todos los productos tengan cantidad válida
        for (const item of formData.items) {
            if (!item.producto || !item.cantidad || item.cantidad < 1) {
                this.mostrarError('Todos los productos deben tener una cantidad válida');
                return false;
            }
        }

        return true;
    }

    limpiarFormulario() {
        document.getElementById('formNuevoPedido').reset();
        document.getElementById('listaProductos').innerHTML = '';
        document.getElementById('direccionPedido').innerHTML = '<option value="">Seleccionar dirección...</option>';
        document.getElementById('direccionPedido').disabled = true;
        this.actualizarTotal();
    }

    // ==================== MÉTODOS CORREGIDOS PARA EDITAR Y CANCELAR ====================

    async editarPedido(idPedido) {
        try {
            const response = await fetch(`/api/pedidos/${idPedido}`);
            if (!response.ok) throw new Error('Error cargando pedido');

            const pedido = await response.json();
            this.pedidoEditando = pedido;

            // Crear modal específico para edición
            this.mostrarModalEditarPedido(pedido);

        } catch (error) {
            console.error('Error cargando pedido para editar:', error);
            this.mostrarError('Error al cargar el pedido para editar');
        }
    }

    mostrarModalEditarPedido(pedido) {
        // Crear modal específico para edición
        const modalHTML = `
            <div class="modal" id="modalEditarPedido">
                <div class="modal-content modal-md">
                    <div class="modal-header">
                        <h3><i class="fas fa-edit"></i> Actualizar Estado del Pedido</h3>
                        <button class="btn-close" onclick="pedidosApp.cerrarModalEditar()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="pedido-info">
                            <p><strong>Pedido #${pedido.id_pedido}</strong></p>
                            <p>Cliente: ${pedido.cliente_nombre || 'N/A'}</p>
                            <p>Estado actual: <span class="estado-badge estado-${(pedido.estado_nombre || 'pendiente').toLowerCase().replace(/\s+/g, '-')}">${pedido.estado_nombre || 'Pendiente'}</span></p>
                        </div>
                        <form id="formEditarPedido">
                            <div class="form-group">
                                <label for="nuevoEstadoPedido">Nuevo Estado *</label>
                                <select id="nuevoEstadoPedido" class="form-control" required>
                                    <option value="">Seleccionar estado...</option>
                                    ${this.estadosPedido.map(estado => 
                                        `<option value="${estado.id_estado_pedido}" ${estado.id_estado_pedido == pedido.id_estado_pedido ? 'selected' : ''}>${estado.nombre_estado}</option>`
                                    ).join('')}
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" onclick="pedidosApp.cerrarModalEditar()">
                            Cancelar
                        </button>
                        <button type="button" class="btn btn-primary" onclick="pedidosApp.actualizarEstadoPedido()">
                            <i class="fas fa-save"></i> Actualizar Estado
                        </button>
                    </div>
                </div>
            </div>
        `;

        // Agregar modal al DOM
        document.body.insertAdjacentHTML('beforeend', modalHTML);
        
        // Mostrar modal
        document.getElementById('modalEditarPedido').style.display = 'block';
    }

    cerrarModalEditar() {
        const modal = document.getElementById('modalEditarPedido');
        if (modal) {
            modal.remove();
        }
        this.pedidoEditando = null;
    }

    async actualizarEstadoPedido() {
        try {
            const nuevoEstadoId = document.getElementById('nuevoEstadoPedido').value;

            if (!nuevoEstadoId) {
                this.mostrarError('Por favor seleccione un estado');
                return;
            }

            // Para todos los estados, usar el endpoint de actualización normal
            const formData = {
                id_estado_pedido: parseInt(nuevoEstadoId)
            };

            const response = await fetch(`/api/pedidos/${this.pedidoEditando.id_pedido}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            const result = await response.json();
            
            if (!response.ok) {
                throw new Error(result.error || 'Error actualizando pedido');
            }

            this.mostrarExito('Estado del pedido actualizado exitosamente');
            this.cerrarModalEditar();
            await this.cargarPedidos();

        } catch (error) {
            console.error('Error actualizando pedido:', error);
            this.mostrarError(error.message || 'Error al actualizar el pedido');
        }
    }

    async cancelarPedido(idPedido) {
        const result = await Swal.fire({
            title: '¿Cancelar pedido?',
            text: "El pedido será marcado como cancelado",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sí, cancelar',
            cancelButtonText: 'Volver'
        });

        if (result.isConfirmed) {
            try {
                // Buscar el ID del estado "cancelado"
                const estadoCancelado = this.estadosPedido.find(estado => 
                    estado.nombre_estado.toLowerCase() === 'cancelado'
                );

                if (!estadoCancelado) {
                    throw new Error('No se encontró el estado cancelado');
                }

                const formData = {
                    id_estado_pedido: estadoCancelado.id_estado_pedido
                };

                const response = await fetch(`/api/pedidos/${idPedido}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(formData)
                });

                const result = await response.json();
                
                if (!response.ok) {
                    throw new Error(result.error || 'Error cancelando pedido');
                }

                this.mostrarExito('Pedido cancelado exitosamente');
                await this.cargarPedidos();

            } catch (error) {
                console.error('Error cancelando pedido:', error);
                this.mostrarError(error.message || 'Error al cancelar el pedido');
            }
        }
    }

// ==================== MÉTODOS CORREGIDOS PARA ELIMINAR ====================

    async eliminarPedido(idPedido) {
        const result = await Swal.fire({
            title: '¿Estás seguro?',
            text: "Esta acción no se puede deshacer",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        });

        if (result.isConfirmed) {
            try {
                const response = await fetch(`/api/pedidos/${idPedido}`, {
                    method: 'DELETE'
                });

                const resultData = await response.json();

                if (!response.ok) {
                    const errorMessage = resultData.error || resultData.mensaje || 'Error al eliminar el pedido';
                    throw new Error(errorMessage);
                }

                // Manejar el formato de respuesta del procedimiento
                if (resultData.success === 1) {
                    this.mostrarExito('Pedido eliminado exitosamente');
                    await this.cargarPedidos();
                } else {
                    const errorMessage = resultData.mensaje || 'No se pudo eliminar el pedido';
                    throw new Error(errorMessage);
                }

            } catch (error) {
                console.error('Error eliminando pedido:', error);
                
                // Mensajes de error específicos
                let mensajeError = error.message;
                
                if (error.message.includes('entregas relacionadas')) {
                    mensajeError = 'No se puede eliminar el pedido porque ya tiene entregas asociadas. Solo se pueden eliminar pedidos sin entregas.';
                } else if (error.message.includes('estado actual')) {
                    mensajeError = 'Solo se pueden eliminar pedidos en estado "pendiente".';
                } else if (error.message.includes('500')) {
                    mensajeError = 'Error interno del servidor. El pedido no pudo ser eliminado.';
                }
                
                this.mostrarError(mensajeError);
            }
        }
    }

    // ==================== DETALLES ====================

    async verDetalles(idPedido) {
        try {
            const response = await fetch(`/api/pedidos/${idPedido}`);
            if (!response.ok) throw new Error('Error cargando detalles');

            const pedido = await response.json();
            this.mostrarModalDetalles(pedido);

        } catch (error) {
            console.error('Error cargando detalles:', error);
            this.mostrarError('Error cargando detalles del pedido');
        }
    }

    mostrarModalDetalles(pedido) {
        const content = document.getElementById('detallesPedidoContent');
        content.innerHTML = this.generarHTMLDetalles(pedido);
        document.getElementById('modalDetallesPedido').style.display = 'block';
    }

    cerrarModalDetalles() {
        document.getElementById('modalDetallesPedido').style.display = 'none';
    }

    generarHTMLDetalles(pedido) {
        return `
            <div class="detalles-pedido">
                <div class="detalles-header">
                    <h4>Pedido #${pedido.id_pedido}</h4>
                    <span class="estado-badge estado-${(pedido.estado_nombre || 'pendiente').toLowerCase().replace(/\s+/g, '-')}">
                        ${pedido.estado_nombre || 'Pendiente'}
                    </span>
                </div>
                
                <div class="detalles-info">
                    <div class="info-group">
                        <h5>Información del Cliente</h5>
                        <p><strong>Nombre:</strong> ${pedido.cliente_nombre || 'N/A'}</p>
                        <p><strong>Email:</strong> ${pedido.cliente_email || 'N/A'}</p>
                        <p><strong>Teléfono:</strong> ${pedido.cliente_telefono || 'N/A'}</p>
                        ${pedido.empresa_nombre ? `<p><strong>Empresa:</strong> ${pedido.empresa_nombre}</p>` : ''}
                    </div>
                    
                    <div class="info-group">
                        <h5>Detalles del Pedido</h5>
                        <p><strong>Fecha:</strong> ${this.formatearFecha(pedido.fecha_pedido)}</p>
                        <p><strong>Total:</strong> $${this.formatearPrecio(pedido.total_pedido || 0)}</p>
                        <p><strong>Peso total:</strong> ${pedido.peso_total || 0} kg</p>
                        <p><strong>Volumen total:</strong> ${pedido.volumen_total || 0} m³</p>
                    </div>

                    <div class="info-group">
                        <h5>Dirección de Entrega</h5>
                        <p><strong>Dirección:</strong> ${pedido.direccion_entrega || 'N/A'}</p>
                        <p><strong>Zona:</strong> ${pedido.nombre_zona || 'N/A'}</p>
                    </div>
                </div>
                
                ${pedido.detalles && pedido.detalles.length > 0 ? `
                    <div class="detalles-productos">
                        <h5>Productos (${pedido.detalles.length})</h5>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Producto</th>
                                        <th>Cantidad</th>
                                        <th>Precio Unitario</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${pedido.detalles.map(detalle => `
                                        <tr>
                                            <td>${detalle.nombre_producto}</td>
                                            <td>${detalle.cantidad}</td>
                                            <td>$${this.formatearPrecio(detalle.precio_unitario)}</td>
                                            <td>$${this.formatearPrecio(detalle.subtotal)}</td>
                                        </tr>
                                    `).join('')}
                                </tbody>
                            </table>
                        </div>
                    </div>
                ` : '<p>No hay detalles de productos disponibles.</p>'}
            </div>
        `;
    }

    // ==================== UTILIDADES ====================

    formatearFecha(fechaString) {
        if (!fechaString) return 'N/A';
        const fecha = new Date(fechaString);
        return fecha.toLocaleDateString('es-ES') + ' ' + fecha.toLocaleTimeString('es-ES');
    }

    formatearPrecio(precio) {
        return parseFloat(precio).toFixed(2);
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaPedidos');
        tbody.innerHTML = `
            <tr>
                <td colspan="8" class="text-center">
                    <div class="loading-spinner">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Cargando pedidos...</span>
                    </div>
                </td>
            </tr>
        `;
    }

    mostrarExito(mensaje) {
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: mensaje,
            timer: 3000,
            showConfirmButton: false
        });
    }

    mostrarError(mensaje) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: mensaje,
            confirmButtonText: 'Aceptar'
        });
    }

    mostrarInfo(mensaje) {
        Swal.fire({
            icon: 'info',
            title: 'Información',
            text: mensaje,
            confirmButtonText: 'Entendido'
        });
    }
}

// Inicializar la aplicación de pedidos
document.addEventListener('DOMContentLoaded', () => {
    window.pedidosApp = new PedidosApp();
});