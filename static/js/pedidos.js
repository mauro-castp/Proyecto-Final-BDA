class PedidosApp {
    constructor() {
        this.pedidos = [];
        this.clientes = [];
        this.productos = [];
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.totalRegistros = 0;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            fecha: ''
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
        });

        document.getElementById('filtroFecha').addEventListener('change', (e) => {
            this.filtros.fecha = e.target.value;
        });

        const clienteSelect = document.getElementById('clienteSelect');
        if (clienteSelect) {
            clienteSelect.addEventListener('change', (e) => {
                this.cargarDireccionesCliente(e.target.value);
            });
        }

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

        // Eventos de productos en modal
        document.addEventListener('change', (e) => {
            if (e.target.classList.contains('producto-select')) {
                this.actualizarPrecioProducto(e.target);
            }
            if (e.target.classList.contains('cantidad-input')) {
                this.actualizarSubtotalProducto(e.target);
            }
        });
    }

    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarClientes(),
                this.cargarProductos()
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
        const response = await fetch('/api/clientes');
        if (!response.ok) throw new Error('Error cargando clientes');
        this.clientes = await response.json();
    }

    async cargarProductos() {
        const response = await fetch('/api/productos');
        if (!response.ok) throw new Error('Error cargando productos');
        this.productos = await response.json();
    }

    resetDireccionesSelect() {
        const select = document.getElementById('direccionEntrega');
        if (!select) return;
        select.innerHTML = '<option value="">Seleccionar dirección...</option>';
        select.value = '';
        select.disabled = true;
    }

    async cargarDireccionesCliente(clienteId) {
        const select = document.getElementById('direccionEntrega');
        if (!select) return;

        this.resetDireccionesSelect();
        if (!clienteId) return;

        try {
            const response = await fetch(`/api/clientes/${clienteId}/direcciones`);
            if (!response.ok) throw new Error('Error cargando direcciones');
            const direcciones = await response.json();

            if (direcciones.length === 0) {
                select.innerHTML += '<option value="" disabled>Sin direcciones registradas</option>';
                select.disabled = false;
                return;
            }

            select.innerHTML += direcciones.map(dir => `
                <option value="${dir.id_direccion}">
                    ${dir.direccion}${dir.es_principal ? ' (Principal)' : ''}
                </option>
            `).join('');
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
                    <td colspan="7" class="text-center">
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
                <td>${this.formatearFecha(pedido.fecha_pedido)}</td>
                <td>${pedido.cantidad_productos || 0} productos</td>
                <td>$${this.formatearPrecio(pedido.total_pedido || 0)}</td>
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
                        <button class="btn-action btn-edit" onclick="pedidosApp.editarPedido(${pedido.id_pedido})" title="Editar">
                            <i class="fas fa-edit"></i>
                        </button>
                    ` : ''}
                    ${this.puedeCancelar(pedido) ? `
                        <button class="btn-action btn-cancel" onclick="pedidosApp.cancelarPedido(${pedido.id_pedido})" title="Cancelar">
                            <i class="fas fa-times"></i>
                        </button>
                    ` : ''}
                </td>
            </tr>
        `).join('');
    }

    puedeEditar(pedido) {
        const estado = pedido.estado_nombre?.toLowerCase();
        return estado === 'pendiente' || estado === 'procesando';
    }

    puedeCancelar(pedido) {
        const estado = pedido.estado_nombre?.toLowerCase();
        return estado === 'pendiente' || estado === 'procesando';
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
        for (let i = 1; i <= totalPaginas; i++) {
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

    // Modal Nuevo Pedido
    mostrarModalNuevoPedido() {
        this.limpiarFormulario();
        this.cargarClientesModal();
        this.resetDireccionesSelect();
        this.cargarProductosModal();
        document.getElementById('modalNuevoPedido').style.display = 'block';
    }

    cerrarModal() {
        document.getElementById('modalNuevoPedido').style.display = 'none';
    }

    cargarClientesModal() {
        const select = document.getElementById('clienteSelect');
        select.innerHTML = '<option value="">Seleccionar cliente...</option>' +
            this.clientes.map(cliente =>
                `<option value="${cliente.id_cliente}">${cliente.nombre}</option>`
            ).join('');
    }

    cargarProductosModal() {
        const selects = document.querySelectorAll('.producto-select');
        selects.forEach(select => {
            select.innerHTML = '<option value="">Seleccionar producto...</option>' +
                this.productos.map(producto =>
                    `<option value="${producto.id_producto}" data-precio="${producto.precio_unitario}">
                        ${producto.nombre} - $${this.formatearPrecio(producto.precio_unitario)}
                    </option>`
                ).join('');
        });
    }

    agregarProducto() {
        const lista = document.getElementById('listaProductos');
        const plantilla = document.getElementById('productoPlantilla');
        const nuevoProducto = plantilla.cloneNode(true);

        nuevoProducto.style.display = 'grid';
        nuevoProducto.id = '';
        this.cargarProductosEnSelect(nuevoProducto.querySelector('.producto-select'));

        lista.appendChild(nuevoProducto);
        this.actualizarResumen();
    }

    cargarProductosEnSelect(select) {
        select.innerHTML = '<option value="">Seleccionar producto...</option>' +
            this.productos.map(producto =>
                `<option value="${producto.id_producto}" data-precio="${producto.precio_unitario}">
                    ${producto.nombre} - $${this.formatearPrecio(producto.precio_unitario)}
                </option>`
            ).join('');
    }

    eliminarProducto(boton) {
        const productoItem = boton.closest('.producto-item');
        productoItem.remove();
        this.actualizarResumen();
    }

    actualizarPrecioProducto(select) {
        const productoItem = select.closest('.producto-item');
        const precioUnitario = productoItem.querySelector('.precio-unitario');
        const opcionSeleccionada = select.selectedOptions[0];

        if (opcionSeleccionada && opcionSeleccionada.value) {
            const precio = opcionSeleccionada.getAttribute('data-precio') || '0';
            precioUnitario.textContent = `$${this.formatearPrecio(precio)}`;
            this.actualizarSubtotalProducto(select);
        } else {
            precioUnitario.textContent = '$0.00';
            productoItem.querySelector('.subtotal').textContent = '$0.00';
        }
    }

    actualizarSubtotalProducto(elemento) {
        const productoItem = elemento.closest('.producto-item');
        const select = productoItem.querySelector('.producto-select');
        const cantidadInput = productoItem.querySelector('.cantidad-input');
        const subtotalSpan = productoItem.querySelector('.subtotal');

        const precio = parseFloat(select.selectedOptions[0]?.getAttribute('data-precio') || 0);
        const cantidad = parseInt(cantidadInput.value) || 0;
        const subtotal = precio * cantidad;

        subtotalSpan.textContent = `$${this.formatearPrecio(subtotal)}`;
        this.actualizarResumen();
    }

    actualizarResumen() {
        let subtotal = 0;

        document.querySelectorAll('.producto-item').forEach(item => {
            if (item.id === 'productoPlantilla' || item.style.display === 'none') {
                return;
            }
            const subtotalTexto = item.querySelector('.subtotal').textContent;
            subtotal += parseFloat(subtotalTexto.replace('$', '')) || 0;
        });

        const envio = subtotal > 0 ? 5.00 : 0; // Envio fijo de ejemplo
        const total = subtotal + envio;

        document.getElementById('subtotalTotal').textContent = `$${this.formatearPrecio(subtotal)}`;
        document.getElementById('costoEnvio').textContent = `$${this.formatearPrecio(envio)}`;
        document.getElementById('totalPedido').textContent = `$${this.formatearPrecio(total)}`;
    }

    async crearPedido() {
        try {
            const formData = this.obtenerDatosFormulario();

            if (!this.validarFormulario(formData)) {
                return;
            }

            const response = await fetch('/api/pedidos', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });

            if (!response.ok) throw new Error('Error creando pedido');

            const result = await response.json();
            this.mostrarExito('Pedido creado exitosamente');
            this.cerrarModal();
            this.cargarPedidos();

        } catch (error) {
            console.error('Error creando pedido:', error);
            this.mostrarError('Error al crear el pedido');
        }
    }

    obtenerDatosFormulario() {
        const productos = [];

        document.querySelectorAll('.producto-item').forEach(item => {
            if (item.id === 'productoPlantilla' || item.style.display === 'none') {
                return;
            }

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
            id_cliente: parseInt(document.getElementById('clienteSelect').value),
            id_direccion: parseInt(document.getElementById('direccionEntrega').value),
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

        return true;
    }

    limpiarFormulario() {
        document.getElementById('formNuevoPedido').reset();
        document.getElementById('listaProductos').innerHTML = '';
        this.agregarProducto(); // Agregar un producto por defecto
        this.actualizarResumen();
        this.resetDireccionesSelect();
    }

    // Otras funcionalidades
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
                    </div>
                    
                    <div class="info-group">
                        <h5>Detalles del Pedido</h5>
                        <p><strong>Fecha:</strong> ${this.formatearFecha(pedido.fecha_pedido)}</p>
                        <p><strong>Total:</strong> $${this.formatearPrecio(pedido.total_pedido || 0)}</p>
                        <p><strong>Peso total:</strong> ${pedido.peso_total || 0} kg</p>
                    </div>
                </div>
                
                ${pedido.detalles ? `
                    <div class="detalles-productos">
                        <h5>Productos</h5>
                        <div class="productos-lista">
                            ${pedido.detalles.map(detalle => `
                                <div class="producto-detalle">
                                    <span>${detalle.nombre_producto}</span>
                                    <span>${detalle.cantidad} x $${this.formatearPrecio(detalle.precio_unitario)}</span>
                                    <span>$${this.formatearPrecio(detalle.subtotal)}</span>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                ` : ''}
            </div>
        `;
    }

    async cancelarPedido(idPedido) {
        if (!confirm('¿Está seguro de que desea cancelar este pedido?')) {
            return;
        }

        try {
            const motivo = prompt('Ingrese el motivo de la cancelación:');
            if (!motivo) return;

            const response = await fetch(`/api/pedidos/${idPedido}/cancelar`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ motivo })
            });

            if (!response.ok) throw new Error('Error cancelando pedido');

            this.mostrarExito('Pedido cancelado exitosamente');
            this.cargarPedidos();

        } catch (error) {
            console.error('Error cancelando pedido:', error);
            this.mostrarError('Error al cancelar el pedido');
        }
    }

    // Utilidades
    formatearFecha(fechaString) {
        if (!fechaString) return 'N/A';
        const fecha = new Date(fechaString);
        return fecha.toLocaleDateString('es-ES');
    }

    formatearPrecio(precio) {
        return parseFloat(precio).toFixed(2);
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaPedidos');
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="text-center">
                    <div class="loading-spinner">
                        <i class="fas fa-spinner fa-spin"></i>
                        <span>Cargando pedidos...</span>
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

// Inicializar la aplicación de pedidos
document.addEventListener('DOMContentLoaded', () => {
    window.pedidosApp = new PedidosApp();
});