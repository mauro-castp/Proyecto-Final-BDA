// entregas.js - Gestión completa de entregas con SweetAlert2
class EntregasApp {
    constructor() {
        this.entregas = [];
        this.pedidosPendientes = [];
        this.rutas = [];
        this.vehiculos = [];
        this.repartidores = [];
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            repartidor: '',
            fecha: ''
        };
        this.entregaSeleccionada = null;
        this.modoEdicion = false;
        this.init();
    }

    init() {
        console.log('🚚 Inicializando módulo de entregas...');
        this.bindEvents();
        this.cargarDatosIniciales();
        this.cargarEntregas();
    }

    bindEvents() {
        // Filtros
        document.getElementById('filtroEstado')?.addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
            this.aplicarFiltros();
        });

        document.getElementById('filtroRepartidor')?.addEventListener('change', (e) => {
            this.filtros.repartidor = e.target.value;
            this.aplicarFiltros();
        });

        document.getElementById('filtroFecha')?.addEventListener('change', (e) => {
            this.filtros.fecha = e.target.value;
            this.aplicarFiltros();
        });

        // Búsqueda en tiempo real
        const buscarInput = document.getElementById('buscarEntregas');
        if (buscarInput) {
            buscarInput.addEventListener('input', (e) => {
                this.buscarEntregas(e.target.value);
            });
        }
    }

    // ==================== CARGA DE DATOS ====================

    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarRepartidores(),
                this.cargarPedidosPendientes(),
                this.cargarRutas(),
                this.cargarVehiculos()
            ]);
            console.log('✅ Datos iniciales cargados correctamente');
        } catch (error) {
            console.error('Error cargando datos iniciales:', error);
            await this.mostrarError('Error cargando datos del sistema');
        }
    }

    async cargarRepartidores() {
        try {
            const response = await fetch('/api/entregas/repartidores');
            if (response.ok) {
                this.repartidores = await response.json();

                // Llenar filtro de repartidores
                const select = document.getElementById('filtroRepartidor');
                if (select) {
                    select.innerHTML = '<option value="">Todos los repartidores</option>' +
                        this.repartidores.map(repartidor =>
                            `<option value="${repartidor.id_usuario}">${repartidor.nombre}</option>`
                        ).join('');
                }

                // Llenar select de repartidores en modal
                const selectModal = document.getElementById('repartidorSelect');
                if (selectModal) {
                    selectModal.innerHTML = '<option value="">Seleccionar repartidor...</option>' +
                        this.repartidores.map(repartidor =>
                            `<option value="${repartidor.id_usuario}">${repartidor.nombre}</option>`
                        ).join('');
                }
            }
        } catch (error) {
            console.error('Error cargando repartidores:', error);
        }
    }

    async cargarPedidosPendientes() {
        try {
            const response = await fetch('/api/entregas/pedidos-pendientes');
            if (response.ok) {
                const data = await response.json();
                this.pedidosPendientes = Array.isArray(data) ? data : [];

                // Llenar select de pedidos en modal
                const select = document.getElementById('pedidoSelect');
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar pedido...</option>' +
                        this.pedidosPendientes.map(pedido =>
                            `<option value="${pedido.id_pedido}">Pedido #${pedido.id_pedido} - ${pedido.nombre_cliente || 'Cliente'}</option>`
                        ).join('');
                }
            }
        } catch (error) {
            console.error('Error cargando pedidos pendientes:', error);
        }
    }

    async cargarRutas() {
        try {
            const response = await fetch('/api/rutas?estado=activa');
            if (response.ok) {
                this.rutas = await response.json();

                const select = document.getElementById('rutaSelect');
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar ruta...</option>' +
                        this.rutas.map(ruta =>
                            `<option value="${ruta.id_ruta}">${ruta.nombre_ruta || `Ruta ${ruta.id_ruta}`}</option>`
                        ).join('');
                }
            }
        } catch (error) {
            console.error('Error cargando rutas:', error);
        }
    }

    async cargarVehiculos() {
        try {
            const response = await fetch('/api/entregas/vehiculos');
            if (response.ok) {
                this.vehiculos = await response.json();

                const select = document.getElementById('vehiculoSelect');
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar vehículo...</option>' +
                        this.vehiculos.map(vehiculo =>
                            `<option value="${vehiculo.id_vehiculo}">${vehiculo.placa} - ${vehiculo.tipo_vehiculo}</option>`
                        ).join('');
                }
            }
        } catch (error) {
            console.error('Error cargando vehículos:', error);
        }
    }

    // ==================== CRUD OPERATIONS ====================

    // CREATE - Asignar nueva entrega
    async guardarEntrega() {
        const form = document.getElementById('formNuevaEntrega');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            id_pedido: parseInt(formData.get('pedidoSelect')),
            id_ruta: formData.get('rutaSelect') ? parseInt(formData.get('rutaSelect')) : null,
            id_vehiculo: parseInt(formData.get('vehiculoSelect')),
            id_repartidor: parseInt(formData.get('repartidorSelect'))
        };

        try {
            const result = await Swal.fire({
                title: '¿Asignar entrega?',
                text: '¿Está seguro de que desea asignar esta entrega?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, asignar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33'
            });

            if (!result.isConfirmed) return;

            const response = await fetch('/api/entregas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const responseData = await response.json();

            if (!response.ok) {
                throw new Error(responseData.error || 'Error asignando entrega');
            }

            await Swal.fire({
                title: '¡Éxito!',
                text: 'Entrega asignada correctamente',
                icon: 'success',
                confirmButtonColor: '#3085d6'
            });

            this.cerrarModal();
            this.cargarEntregas();

        } catch (error) {
            console.error('Error asignando entrega:', error);
            await Swal.fire({
                title: 'Error',
                text: 'Error al asignar la entrega: ' + error.message,
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        }
    }

    // READ - Cargar entregas
    async cargarEntregas() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                ...this.filtros
            });

            // Determinar el endpoint según el rol
            const endpoint = this.esRepartidor() ? '/api/mis-entregas' : '/api/entregas';
            
            const response = await fetch(`${endpoint}?${params}`, {
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}: ${response.statusText}`);

            const data = await response.json();
            this.entregas = data.entregas || [];
            
            // Manejar la nueva estructura de paginación
            if (data.paginacion) {
                this.totalPaginas = data.paginacion.total_paginas || 1;
                this.totalRegistros = data.paginacion.total_registros || 0;
            } else {
                this.totalPaginas = data.total_paginas || 1;
                this.totalRegistros = data.total || 0;
            }

            this.actualizarTabla();
            this.actualizarEstadisticas();
            this.actualizarPaginacion();

        } catch (error) {
            console.error('Error cargando entregas:', error);
            await this.mostrarError('Error cargando la lista de entregas: ' + error.message);
        }
    }

    // UPDATE - Confirmar entrega
    async confirmarEntrega() {
        const form = document.getElementById('formConfirmarEntrega');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            hora_real: formData.get('horaReal') + ':00',
            evidencia_url: formData.get('evidencia') || ''
        };

        try {
            const result = await Swal.fire({
                title: '¿Confirmar entrega?',
                text: '¿Está seguro de que desea confirmar esta entrega como completada?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Sí, confirmar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#28a745',
                cancelButtonColor: '#d33'
            });

            if (!result.isConfirmed) return;

            const response = await fetch(`/api/entregas/${this.entregaSeleccionada}/confirmar`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const responseData = await response.json();

            if (!response.ok) {
                throw new Error(responseData.error || 'Error confirmando entrega');
            }

            await Swal.fire({
                title: '¡Éxito!',
                text: 'Entrega confirmada correctamente',
                icon: 'success',
                confirmButtonColor: '#28a745'
            });

            this.cerrarModalConfirmar();
            this.cargarEntregas();

        } catch (error) {
            console.error('Error confirmando entrega:', error);
            await Swal.fire({
                title: 'Error',
                text: 'Error al confirmar la entrega: ' + error.message,
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        }
    }

    // UPDATE - Registrar reintento
    async registrarReintento() {
        const form = document.getElementById('formReintentoEntrega');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            motivo_fallo: parseInt(formData.get('motivoReintento'))
        };

        try {
            const result = await Swal.fire({
                title: '¿Registrar reintento?',
                text: '¿Está seguro de que desea registrar un reintento para esta entrega?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, registrar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#ffc107',
                cancelButtonColor: '#d33'
            });

            if (!result.isConfirmed) return;

            const response = await fetch(`/api/entregas/${this.entregaSeleccionada}/reintento`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            const responseData = await response.json();

            if (!response.ok) {
                throw new Error(responseData.error || 'Error registrando reintento');
            }

            await Swal.fire({
                title: '¡Reintento registrado!',
                text: 'El reintento ha sido registrado correctamente',
                icon: 'success',
                confirmButtonColor: '#ffc107'
            });

            this.cerrarModalReintento();
            this.cargarEntregas();

        } catch (error) {
            console.error('Error registrando reintento:', error);
            await Swal.fire({
                title: 'Error',
                text: 'Error al registrar el reintento: ' + error.message,
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        }
    }

    // DELETE - Eliminar entrega
    async eliminarEntrega(idEntrega) {
        try {
            const result = await Swal.fire({
                title: '¿Eliminar entrega?',
                text: 'Esta acción no se puede deshacer. ¿Está seguro de que desea eliminar esta entrega?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                reverseButtons: true
            });

            if (!result.isConfirmed) return;

            const response = await fetch(`/api/entregas/${idEntrega}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            const responseData = await response.json();

            if (!response.ok) {
                throw new Error(responseData.error || 'Error eliminando entrega');
            }

            await Swal.fire({
                title: '¡Eliminada!',
                text: 'La entrega ha sido eliminada correctamente',
                icon: 'success',
                confirmButtonColor: '#3085d6'
            });

            this.cargarEntregas();

        } catch (error) {
            console.error('Error eliminando entrega:', error);
            await Swal.fire({
                title: 'Error',
                text: 'Error al eliminar la entrega: ' + error.message,
                icon: 'error',
                confirmButtonColor: '#d33'
            });
        }
    }

    // ==================== MODALES ====================

    mostrarModalNuevaEntrega() {
        this.modoEdicion = false;
        this.cerrarTodosModales();
        document.getElementById('modalNuevaEntrega').style.display = 'block';
        document.getElementById('formNuevaEntrega').reset();
        document.getElementById('infoPedido').style.display = 'none';
        this.cargarDatosParaModal();
    }

    cerrarModal() {
        document.getElementById('modalNuevaEntrega').style.display = 'none';
    }

    async mostrarModalDetalles(idEntrega) {
        await this.verDetalles(idEntrega);
    }

    cerrarModalDetalles() {
        document.getElementById('modalDetallesEntrega').style.display = 'none';
    }

    mostrarModalConfirmar(idEntrega) {
        this.entregaSeleccionada = idEntrega;
        this.cargarDatosParaConfirmar(idEntrega);
        this.cerrarTodosModales();
        document.getElementById('modalConfirmarEntrega').style.display = 'block';
    }

    cerrarModalConfirmar() {
        document.getElementById('modalConfirmarEntrega').style.display = 'none';
        document.getElementById('formConfirmarEntrega').reset();
    }

    mostrarModalReintento(idEntrega) {
        this.entregaSeleccionada = idEntrega;
        document.getElementById('entregaIdReintento').value = idEntrega;
        this.cerrarTodosModales();
        document.getElementById('modalReintentoEntrega').style.display = 'block';
    }

    cerrarModalReintento() {
        document.getElementById('modalReintentoEntrega').style.display = 'none';
        document.getElementById('formReintentoEntrega').reset();
    }

    cerrarTodosModales() {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.style.display = 'none';
        });
    }

    // ==================== FUNCIONES ADICIONALES ====================

    async cargarDatosParaModal() {
        await Promise.all([
            this.cargarPedidosPendientes(),
            this.cargarRutas(),
            this.cargarVehiculos(),
            this.cargarRepartidores()
        ]);
    }

    async cargarDatosParaConfirmar(idEntrega) {
        try {
            const response = await fetch(`/api/entregas/${idEntrega}`);
            if (response.ok) {
                const entrega = await response.json();
                document.getElementById('confirmarPedido').textContent = `#${entrega.id_pedido}`;
                document.getElementById('confirmarCliente').textContent = entrega.nombre_cliente || 'N/A';
                document.getElementById('confirmarDireccion').textContent = entrega.direccion || 'N/A';
                document.getElementById('entregaIdConfirmar').value = idEntrega;

                // Establecer hora actual como predeterminada
                const ahora = new Date();
                document.getElementById('horaReal').value = ahora.toISOString().slice(0, 16);
            }
        } catch (error) {
            console.error('Error cargando detalles para confirmar:', error);
        }
    }

    async cargarInfoPedido(idPedido) {
        if (!idPedido) {
            document.getElementById('infoPedido').style.display = 'none';
            return;
        }

        try {
            const response = await fetch(`/api/pedidos/${idPedido}`);
            if (response.ok) {
                const pedido = await response.json();
                document.getElementById('infoCliente').textContent = pedido.nombre_cliente || 'N/A';
                document.getElementById('infoDireccion').textContent = pedido.direccion_entrega || 'N/A';
                document.getElementById('infoProductos').textContent = this.formatearProductos(pedido.items || []);
                document.getElementById('infoTotal').textContent = this.formatearMoneda(pedido.total_pedido || 0);
                document.getElementById('infoPedido').style.display = 'block';
            }
        } catch (error) {
            console.error('Error cargando info del pedido:', error);
        }
    }

    // ==================== RENDERIZADO ====================

    actualizarTabla() {
        const tbody = document.getElementById('tablaEntregas');
        if (!tbody) return;

        if (this.entregas.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center py-4">
                        <div class="no-results">
                            <i class="fas fa-box-open fa-2x mb-2"></i>
                            <p>No se encontraron entregas</p>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.entregas.map(entrega => `
            <tr class="${this.obtenerClaseFila(entrega)}" data-entrega-id="${entrega.id_entrega}">
                <td>${entrega.nombre_cliente || 'N/A'}</td>
                <td>${entrega.nombre_repartidor || 'No asignado'}</td>
                <td>${entrega.nombre_ruta || 'N/A'}</td>
                <td>
                    <span class="tiempo-estimado ${this.obtenerClaseTiempo(entrega)}">
                        ${this.formatearFechaHora(entrega.fecha_estimada_entrega)}
                        ${this.estaAtrasada(entrega) ? ' ⚠️' : ''}
                    </span>
                </td>
                <td>
                    <span class="estado-badge estado-${this.getEstadoSlug(entrega.id_estado_entrega)}">
                        ${entrega.estado_nombre || this.getEstadoTexto(entrega.id_estado_entrega)}
                        ${entrega.reintentos > 0 ? 
                            `<span class="reintentos-badge ${entrega.reintentos >= 3 ? 'reintentos-max' : ''}">
                                ${entrega.reintentos}
                            </span>` : ''
                        }
                    </span>
                </td>
                <td class="acciones-cell">
                    <div class="btn-group">
                        <button class="btn-action btn-view" onclick="entregasApp.mostrarModalDetalles(${entrega.id_entrega})" 
                                title="Ver detalles">
                            <i class="fas fa-eye"></i>
                        </button>
                        
                        ${this.puedeConfirmar(entrega) ? `
                            <button class="btn-action btn-confirm" onclick="entregasApp.mostrarModalConfirmar(${entrega.id_entrega})" 
                                    title="Confirmar entrega">
                                <i class="fas fa-check"></i>
                            </button>
                        ` : ''}
                        
                        ${this.puedeReintentar(entrega) ? `
                            <button class="btn-action btn-retry" onclick="entregasApp.mostrarModalReintento(${entrega.id_entrega})" 
                                    title="Registrar reintento">
                                <i class="fas fa-redo"></i>
                            </button>
                        ` : ''}
                        
                        ${this.puedeReasignar(entrega) ? `
                            <button class="btn-action btn-edit" onclick="entregasApp.mostrarModalReasignar(${entrega.id_entrega})" 
                                    title="Reasignar repartidor">
                                <i class="fas fa-user-edit"></i>
                            </button>
                        ` : ''}
                        
                        ${this.puedeCambiarEstado(entrega) ? `
                            <button class="btn-action btn-state" onclick="entregasApp.mostrarModalCambiarEstado(${entrega.id_entrega})" 
                                    title="Cambiar estado">
                                <i class="fas fa-exchange-alt"></i>
                            </button>
                        ` : ''}
                        
                        ${this.puedeEliminar(entrega) ? `
                            <button class="btn-action btn-delete" onclick="entregasApp.eliminarEntrega(${entrega.id_entrega})" 
                                    title="Eliminar entrega">
                                <i class="fas fa-trash"></i>
                            </button>
                        ` : ''}
                    </div>
                </td>
            </tr>
        `).join('');
    }

    actualizarEstadisticas() {
        const total = this.entregas.length;
        const pendientes = this.entregas.filter(e => [1, 2, 3, 4].includes(e.id_estado_entrega)).length;
        const enCamino = this.entregas.filter(e => e.id_estado_entrega === 3).length;
        const exitosas = this.entregas.filter(e => e.id_estado_entrega === 5).length;
        const tasaExito = total > 0 ? Math.round((exitosas / total) * 100) : 0;

        if (document.getElementById('totalEntregas')) document.getElementById('totalEntregas').textContent = total;
        if (document.getElementById('entregasPendientes')) document.getElementById('entregasPendientes').textContent = pendientes;
        if (document.getElementById('entregasCamino')) document.getElementById('entregasCamino').textContent = enCamino;
        if (document.getElementById('entregasExitosas')) document.getElementById('entregasExitosas').textContent = exitosas;
        if (document.getElementById('tasaExito')) document.getElementById('tasaExito').textContent = `${tasaExito}%`;
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
        const fin = Math.min(this.paginaActual * this.registrosPorPagina, this.totalRegistros);

        if (mostrandoDesde) mostrandoDesde.textContent = inicio;
        if (mostrandoHasta) mostrandoHasta.textContent = fin;
        if (totalRegistros) totalRegistros.textContent = this.totalRegistros;

        if (paginationNumbers) {
            paginationNumbers.innerHTML = '';
            for (let i = 1; i <= this.totalPaginas; i++) {
                const btn = document.createElement('button');
                btn.className = `btn-pagination ${i === this.paginaActual ? 'active' : ''}`;
                btn.textContent = i;
                btn.onclick = () => {
                    this.paginaActual = i;
                    this.cargarEntregas();
                };
                paginationNumbers.appendChild(btn);
            }
        }
    }

    // ==================== UTILIDADES ====================

    aplicarFiltros() {
        this.paginaActual = 1;
        this.cargarEntregas();
    }

    buscarEntregas(termino) {
        if (!termino) {
            this.actualizarTabla();
            return;
        }

        const terminoLower = termino.toLowerCase();
        const entregasFiltradas = this.entregas.filter(entrega =>
            entrega.id_entrega.toString().includes(termino) ||
            entrega.id_pedido.toString().includes(termino) ||
            (entrega.nombre_cliente && entrega.nombre_cliente.toLowerCase().includes(terminoLower)) ||
            (entrega.nombre_repartidor && entrega.nombre_repartidor.toLowerCase().includes(terminoLower))
        );

        // Renderizar tabla filtrada
        const tbody = document.getElementById('tablaEntregas');
        if (tbody) {
            if (entregasFiltradas.length === 0) {
                tbody.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center">
                            <div class="loading-spinner">
                                <i class="fas fa-search"></i>
                                <span>No se encontraron entregas con "${termino}"</span>
                            </div>
                        </td>
                    </tr>
                `;
            } else {
                // Reutilizar la lógica de renderizado pero con datos filtrados
                const entregasOriginales = this.entregas;
                this.entregas = entregasFiltradas;
                this.actualizarTabla();
                this.entregas = entregasOriginales;
            }
        }
    }

    // ==================== SWEETALERT2 NOTIFICATIONS ====================

    async mostrarExito(mensaje, titulo = '¡Éxito!') {
        await Swal.fire({
            title: titulo,
            text: mensaje,
            icon: 'success',
            confirmButtonColor: '#3085d6',
            timer: 3000,
            showConfirmButton: false
        });
    }

    async mostrarError(mensaje, titulo = 'Error') {
        await Swal.fire({
            title: titulo,
            text: mensaje,
            icon: 'error',
            confirmButtonColor: '#d33'
        });
    }

    async mostrarInfo(mensaje, titulo = 'Información') {
        await Swal.fire({
            title: titulo,
            text: mensaje,
            icon: 'info',
            confirmButtonColor: '#3085d6',
            timer: 3000,
            showConfirmButton: false
        });
    }

    // ==================== MÉTODOS DE DETALLES ====================

    async verDetalles(idEntrega) {
        try {
            const response = await fetch(`/api/entregas/${idEntrega}`);
            if (response.ok) {
                const entrega = await response.json();
                
                await Swal.fire({
                    title: `Detalles de Entrega #${entrega.id_entrega}`,
                    html: `
                        <div class="text-left">
                            <p><strong>Pedido:</strong> #${entrega.id_pedido}</p>
                            <p><strong>Cliente:</strong> ${entrega.nombre_cliente || 'N/A'}</p>
                            <p><strong>Repartidor:</strong> ${entrega.nombre_repartidor || 'No asignado'}</p>
                            <p><strong>Estado:</strong> ${entrega.estado_nombre || 'N/A'}</p>
                            <p><strong>Fecha estimada:</strong> ${this.formatearFechaHora(entrega.fecha_estimada_entrega)}</p>
                            <p><strong>Fecha real:</strong> ${entrega.fecha_real_entrega ? this.formatearFechaHora(entrega.fecha_real_entrega) : 'Pendiente'}</p>
                            <p><strong>Reintentos:</strong> ${entrega.reintentos || 0}</p>
                            <p><strong>Dirección:</strong> ${entrega.direccion || 'N/A'}</p>
                            <p><strong>Zona:</strong> ${entrega.nombre_zona || 'N/A'}</p>
                        </div>
                    `,
                    confirmButtonText: 'Cerrar',
                    confirmButtonColor: '#3085d6',
                    width: '600px'
                });
            } else {
                throw new Error('Error cargando detalles');
            }
        } catch (error) {
            console.error('Error cargando detalles:', error);
            await this.mostrarError('Error al cargar los detalles de la entrega');
        }
    }

    // ==================== FUNCIONES DE APOYO ====================

    obtenerClaseFila(entrega) {
        if (this.estaAtrasada(entrega)) return 'fila-urgente';
        if (this.esUrgente(entrega)) return 'fila-alerta';
        return '';
    }

    obtenerClaseTiempo(entrega) {
        if (this.estaAtrasada(entrega)) return 'tiempo-retrasado';
        if (this.esProxima(entrega)) return 'tiempo-proximo';
        return 'tiempo-cumplido';
    }

    estaAtrasada(entrega) {
        if (!entrega.fecha_estimada_entrega || entrega.id_estado_entrega === 5) return false;
        const estimada = new Date(entrega.fecha_estimada_entrega);
        const ahora = new Date();
        return estimada < ahora;
    }

    esProxima(entrega) {
        if (!entrega.fecha_estimada_entrega || entrega.id_estado_entrega === 5) return false;
        const estimada = new Date(entrega.fecha_estimada_entrega);
        const ahora = new Date();
        const unaHora = 60 * 60 * 1000;
        return (estimada - ahora) <= unaHora;
    }

    esUrgente(entrega) {
        return this.estaAtrasada(entrega) || (entrega.reintentos || 0) >= 2;
    }

    puedeConfirmar(entrega) {
        if (this.esRepartidor() && entrega.id_repartidor !== this.obtenerUserId()) {
            return false;
        }
        return [1, 2, 3, 4].includes(entrega.id_estado_entrega); // Pendiente, Asignada, En Camino, En Destino
    }

    puedeReintentar(entrega) {
        if (this.esRepartidor() && entrega.id_repartidor !== this.obtenerUserId()) {
            return false;
        }
        return entrega.id_estado_entrega === 6 && (entrega.reintentos || 0) < 3; // Fallida con menos de 3 reintentos
    }

    puedeReasignar(entrega) {
        if (this.esRepartidor()) return false;
        return [1, 6].includes(entrega.id_estado_entrega); // Pendiente o Fallida
    }

    puedeCambiarEstado(entrega) {
        if (this.esRepartidor()) return false;
        return true; // Admin y planificador pueden cambiar cualquier estado
    }

    puedeEliminar(entrega) {
        if (this.esRepartidor()) return false;
        // Solo se pueden eliminar entregas en estado pendiente
        return entrega.id_estado_entrega === 1;
    }

    getEstadoSlug(idEstado) {
        const estados = {
            1: 'pendiente',
            2: 'asignada',
            3: 'en_camino',
            4: 'en_destino',
            5: 'entregada',
            6: 'fallida'
        };
        return estados[idEstado] || 'pendiente';
    }

    getEstadoTexto(idEstado) {
        const estados = {
            1: 'Pendiente',
            2: 'Asignada',
            3: 'En Camino',
            4: 'En Destino',
            5: 'Entregada',
            6: 'Fallida'
        };
        return estados[idEstado] || 'Desconocido';
    }

    formatearFechaHora(fechaString) {
        if (!fechaString) return 'N/A';
        const fecha = new Date(fechaString);
        return fecha.toLocaleString('es-ES');
    }

    formatearProductos(items) {
        if (!items || !Array.isArray(items)) return 'N/A';
        return items.map(p => `${p.cantidad || 1}x ${p.nombre_producto || 'Producto'}`).join(', ');
    }

    formatearMoneda(monto) {
        return new Intl.NumberFormat('es-MX', {
            style: 'currency',
            currency: 'MXN'
        }).format(monto);
    }

    esRepartidor() {
        return typeof userRole !== 'undefined' && userRole === 3; // Rol 3 = Repartidor
    }

    obtenerUserId() {
        return typeof userId !== 'undefined' ? userId : null;
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaEntregas');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="6" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-spinner fa-spin"></i>
                            <span>Cargando entregas...</span>
                        </div>
                    </td>
                </tr>
            `;
        }
    }

    // Métodos placeholder para funcionalidades futuras
    mostrarModalReasignar(idEntrega) {
        this.mostrarInfo('Funcionalidad de reasignación en desarrollo');
    }

    mostrarModalCambiarEstado(idEntrega) {
        this.mostrarInfo('Funcionalidad de cambio de estado en desarrollo');
    }

    actualizarMapa() {
        this.mostrarInfo('Funcionalidad de mapa en desarrollo');
    }
}

// Inicializar la aplicación cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function () {
    window.entregasApp = new EntregasApp();
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