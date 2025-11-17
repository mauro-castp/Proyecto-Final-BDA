// entregas.js - Gestión completa de entregas
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
        });

        document.getElementById('filtroRepartidor')?.addEventListener('change', (e) => {
            this.filtros.repartidor = e.target.value;
        });

        document.getElementById('filtroFecha')?.addEventListener('change', (e) => {
            this.filtros.fecha = e.target.value;
        });

        // Paginación
        document.getElementById('btnAnterior')?.addEventListener('click', () => {
            if (this.paginaActual > 1) {
                this.paginaActual--;
                this.cargarEntregas();
            }
        });

        document.getElementById('btnSiguiente')?.addEventListener('click', () => {
            if (this.paginaActual < this.totalPaginas) {
                this.paginaActual++;
                this.cargarEntregas();
            }
        });

        // Eventos de modales
        document.getElementById('pedidoSelect')?.addEventListener('change', (e) => {
            this.cargarInfoPedido(e.target.value);
        });

        // Búsqueda en tiempo real
        document.getElementById('buscarEntregas')?.addEventListener('input', (e) => {
            this.buscarEntregas(e.target.value);
        });
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
            this.mostrarError('Error cargando datos del sistema');
        }
    }

    async cargarEntregas() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                ...this.filtros
            });

            // Si es repartidor, solo cargar sus entregas
            if (this.esRepartidor()) {
                params.append('repartidor', 'mi');
            }

            const response = await fetch(`/api/entregas?${params}`, {
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}: ${response.statusText}`);

            const data = await response.json();
            this.entregas = Array.isArray(data) ? data : (data.entregas || []);

            // Calcular paginación si no viene del servidor
            this.totalPaginas = data.totalPaginas || Math.ceil(this.entregas.length / this.registrosPorPagina);

            this.actualizarTabla();
            this.actualizarEstadisticas();
            this.actualizarPaginacion();

        } catch (error) {
            console.error('Error cargando entregas:', error);
            this.mostrarError('Error cargando la lista de entregas: ' + error.message);
        }
    }

    async cargarRepartidores() {
        try {
            // En una implementación real, tendrías un endpoint para repartidores
            // Por ahora simulamos la carga
            const response = await fetch('/api/usuarios?rol=Repartidor');
            if (response.ok) {
                this.repartidores = await response.json();
            } else {
                // Datos de ejemplo para desarrollo
                this.repartidores = [
                    { id_usuario: 1, nombre: 'Carlos Rodríguez' },
                    { id_usuario: 2, nombre: 'Ana Martínez' },
                    { id_usuario: 3, nombre: 'Luis García' }
                ];
            }

            // Llenar filtro de repartidores
            const select = document.getElementById('filtroRepartidor');
            if (select) {
                select.innerHTML = '<option value="">Todos los repartidores</option>' +
                    this.repartidores.map(repartidor =>
                        `<option value="${repartidor.id_usuario}">${repartidor.nombre}</option>`
                    ).join('');
            }
        } catch (error) {
            console.error('Error cargando repartidores:', error);
        }
    }

    async cargarPedidosPendientes() {
        try {
            const response = await fetch('/api/pedidos?estado=pendiente');
            if (response.ok) {
                const data = await response.json();
                this.pedidosPendientes = Array.isArray(data) ? data : [];

                // Llenar select de pedidos en modal de asignación
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
            const response = await fetch('/api/vehiculos?estado=disponible');
            if (response.ok) {
                this.vehiculos = await response.json();

                const select = document.getElementById('vehiculoSelect');
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar vehículo...</option>' +
                        this.vehiculos.map(vehiculo =>
                            `<option value="${vehiculo.id_vehiculo}">${vehiculo.placa} - ${vehiculo.tipo}</option>`
                        ).join('');
                }
            }
        } catch (error) {
            console.error('Error cargando vehículos:', error);
        }
    }

    // ==================== RENDERIZADO ====================
    actualizarTabla() {
        const tbody = document.getElementById('tablaEntregas');
        if (!tbody) return;

        if (this.entregas.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-box-open"></i>
                            <span>No se encontraron entregas</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.entregas.map(entrega => `
            <tr class="${this.obtenerClasePrioridad(entrega)}">
                <td><strong>#${entrega.id_entrega}</strong></td>
                <td>
                    <strong>#${entrega.id_pedido}</strong>
                    ${this.esUrgente(entrega) ? '<span class="urgente" title="Entrega urgente">🚨</span>' : ''}
                </td>
                <td>${entrega.nombre_cliente || 'N/A'}</td>
                <td>${entrega.nombre_repartidor || 'No asignado'}</td>
                <td>${entrega.nombre_ruta || 'N/A'}</td>
                <td>
                    <span class="tiempo-estimado ${this.obtenerClaseTiempo(entrega)}">
                        ${this.formatearFechaHora(entrega.fecha_estimada)}
                        ${this.estaAtrasada(entrega) ? ' (Atrasada)' : ''}
                    </span>
                </td>
                <td>
                    <span class="estado-badge estado-${this.getEstadoSlug(entrega.id_estado_entrega)}">
                        ${this.getEstadoTexto(entrega.id_estado_entrega)}
                        ${entrega.reintentos > 0 ?
                `<span class="reintentos-badge ${entrega.reintentos >= 3 ? 'reintentos-max' : ''}">
                                ${entrega.reintentos}
                            </span>` : ''
            }
                    </span>
                </td>
                <td class="acciones-cell">
                    <button class="btn-action btn-view" onclick="entregasApp.verDetalles(${entrega.id_entrega})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${this.puedeConfirmar(entrega) ? `
                        <button class="btn-action btn-confirm" onclick="entregasApp.mostrarModalConfirmar(${entrega.id_entrega})" title="Confirmar entrega">
                            <i class="fas fa-check"></i>
                        </button>
                    ` : ''}
                    ${this.puedeReintentar(entrega) ? `
                        <button class="btn-action btn-retry" onclick="entregasApp.mostrarModalReintento(${entrega.id_entrega})" title="Registrar reintento">
                            <i class="fas fa-redo"></i>
                        </button>
                    ` : ''}
                    ${this.puedeReasignar(entrega) ? `
                        <button class="btn-action btn-edit" onclick="entregasApp.reasignarEntrega(${entrega.id_entrega})" title="Reasignar">
                            <i class="fas fa-edit"></i>
                        </button>
                    ` : ''}
                </td>
            </tr>
        `).join('');
    }

    actualizarEstadisticas() {
        const total = this.entregas.length;
        const pendientes = this.entregas.filter(e => [1, 2].includes(e.id_estado_entrega)).length;
        const enCamino = this.entregas.filter(e => e.id_estado_entrega === 2).length;
        const exitosas = this.entregas.filter(e => e.id_estado_entrega === 4).length;
        const tasaExito = total > 0 ? Math.round((exitosas / total) * 100) : 0;

        document.getElementById('totalEntregas').textContent = total;
        document.getElementById('entregasPendientes').textContent = pendientes;
        document.getElementById('entregasCamino').textContent = enCamino;
        document.getElementById('entregasExitosas').textContent = exitosas;
        document.getElementById('tasaExito').textContent = `${tasaExito}%`;
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
        const fin = Math.min(this.paginaActual * this.registrosPorPagina, this.entregas.length);

        if (mostrandoDesde) mostrandoDesde.textContent = inicio;
        if (mostrandoHasta) mostrandoHasta.textContent = fin;
        if (totalRegistros) totalRegistros.textContent = this.entregas.length;

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

    // ==================== LÓGICA DE ESTADOS ====================
    obtenerClasePrioridad(entrega) {
        if (this.estaAtrasada(entrega)) return 'prioridad-alta';
        if (this.esProxima(entrega)) return 'prioridad-media';
        return 'prioridad-baja';
    }

    obtenerClaseTiempo(entrega) {
        if (this.estaAtrasada(entrega)) return 'tiempo-retrasado';
        if (this.esProxima(entrega)) return 'tiempo-proximo';
        return 'tiempo-cumplido';
    }

    estaAtrasada(entrega) {
        if (!entrega.fecha_estimada || entrega.id_estado_entrega === 4) return false;
        const estimada = new Date(entrega.fecha_estimada);
        const ahora = new Date();
        return estimada < ahora;
    }

    esProxima(entrega) {
        if (!entrega.fecha_estimada || entrega.id_estado_entrega === 4) return false;
        const estimada = new Date(entrega.fecha_estimada);
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
        return [1, 2].includes(entrega.id_estado_entrega); // Pendiente o En camino
    }

    puedeReintentar(entrega) {
        if (this.esRepartidor() && entrega.id_repartidor !== this.obtenerUserId()) {
            return false;
        }
        return entrega.id_estado_entrega === 3 && (entrega.reintentos || 0) < 3; // Fallida con menos de 3 reintentos
    }

    puedeReasignar(entrega) {
        if (this.esRepartidor()) return false;
        return [1, 3].includes(entrega.id_estado_entrega); // Pendiente o Fallida
    }

    getEstadoSlug(idEstado) {
        const estados = {
            1: 'pendiente',
            2: 'en_camino',
            3: 'fallido',
            4: 'entregado',
            5: 'cancelado'
        };
        return estados[idEstado] || 'pendiente';
    }

    getEstadoTexto(idEstado) {
        const estados = {
            1: 'Pendiente',
            2: 'En Camino',
            3: 'Fallido',
            4: 'Entregado',
            5: 'Cancelado'
        };
        return estados[idEstado] || 'Desconocido';
    }

    // ==================== MODALES ====================
    mostrarModalAsignarEntrega() {
        this.cerrarTodosModales();
        document.getElementById('modalAsignarEntrega').style.display = 'block';
    }

    cerrarModalAsignar() {
        document.getElementById('modalAsignarEntrega').style.display = 'none';
        document.getElementById('formAsignarEntrega').reset();
        document.getElementById('infoPedido').style.display = 'none';
    }

    async mostrarModalConfirmar(idEntrega) {
        this.entregaSeleccionada = idEntrega;

        try {
            const response = await fetch(`/api/entregas/${idEntrega}`);
            if (response.ok) {
                const entrega = await response.json();
                document.getElementById('confirmarPedido').textContent = `#${entrega.id_pedido}`;
                document.getElementById('confirmarCliente').textContent = entrega.nombre_cliente || 'N/A';
                document.getElementById('confirmarDireccion').textContent = entrega.direccion_entrega || 'N/A';
                document.getElementById('entregaIdConfirmar').value = idEntrega;

                // Establecer hora actual como predeterminada
                const ahora = new Date();
                document.getElementById('horaReal').value = ahora.toISOString().slice(0, 16);
            }
        } catch (error) {
            console.error('Error cargando detalles para confirmar:', error);
        }

        this.cerrarTodosModales();
        document.getElementById('modalConfirmarEntrega').style.display = 'block';
    }

    cerrarModalConfirmar() {
        document.getElementById('modalConfirmarEntrega').style.display = 'none';
        document.getElementById('formConfirmarEntrega').reset();
        this.entregaSeleccionada = null;
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
        this.entregaSeleccionada = null;
    }

    cerrarTodosModales() {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.style.display = 'none';
        });
    }

    // ==================== ACCIONES ====================
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
                document.getElementById('infoProductos').textContent = this.formatearProductos(pedido.items);
                document.getElementById('infoTotal').textContent = this.formatearMoneda(pedido.total || 0);
                document.getElementById('infoPedido').style.display = 'block';
            }
        } catch (error) {
            console.error('Error cargando info del pedido:', error);
        }
    }

    async asignarEntrega() {
        const form = document.getElementById('formAsignarEntrega');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            pedido_id: parseInt(formData.get('pedidoSelect')),
            ruta_id: parseInt(formData.get('rutaSelect')),
            vehiculo_id: parseInt(formData.get('vehiculoSelect'))
        };

        try {
            const response = await fetch('/api/entregas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) throw new Error('Error asignando entrega');

            this.mostrarExito('Entrega asignada correctamente');
            this.cerrarModalAsignar();
            this.cargarEntregas();

        } catch (error) {
            console.error('Error asignando entrega:', error);
            this.mostrarError('Error al asignar la entrega: ' + error.message);
        }
    }

    async confirmarEntrega() {
        const form = document.getElementById('formConfirmarEntrega');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            hora_real: formData.get('horaReal') + ':00',
            evidencia: formData.get('evidencia') || ''
        };

        try {
            const response = await fetch(`/api/entregas/${this.entregaSeleccionada}/confirmar`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) throw new Error('Error confirmando entrega');

            this.mostrarExito('Entrega confirmada correctamente');
            this.cerrarModalConfirmar();
            this.cargarEntregas();

        } catch (error) {
            console.error('Error confirmando entrega:', error);
            this.mostrarError('Error al confirmar la entrega: ' + error.message);
        }
    }

    async registrarReintento() {
        const form = document.getElementById('formReintentoEntrega');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            motivo: formData.get('motivoReintento') + (formData.get('observacionesReintento') ?
                ': ' + formData.get('observacionesReintento') : '')
        };

        try {
            const response = await fetch(`/api/entregas/${this.entregaSeleccionada}/reintento`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) throw new Error('Error registrando reintento');

            this.mostrarExito('Reintento registrado correctamente');
            this.cerrarModalReintento();
            this.cargarEntregas();

        } catch (error) {
            console.error('Error registrando reintento:', error);
            this.mostrarError('Error al registrar el reintento: ' + error.message);
        }
    }

    async verDetalles(idEntrega) {
        try {
            const response = await fetch(`/api/entregas/${idEntrega}`);
            if (response.ok) {
                const entrega = await response.json();
                this.mostrarDetallesEntrega(entrega);
            }
        } catch (error) {
            console.error('Error cargando detalles:', error);
            this.mostrarError('Error al cargar los detalles de la entrega');
        }
    }

    mostrarDetallesEntrega(entrega) {
        // Implementar modal de detalles específico
        alert(`Detalles de Entrega #${entrega.id_entrega}\n\n` +
            `Pedido: #${entrega.id_pedido}\n` +
            `Cliente: ${entrega.nombre_cliente || 'N/A'}\n` +
            `Estado: ${this.getEstadoTexto(entrega.id_estado_entrega)}\n` +
            `Fecha estimada: ${this.formatearFechaHora(entrega.fecha_estimada)}\n` +
            `Reintentos: ${entrega.reintentos || 0}`);
    }

    reasignarEntrega(idEntrega) {
        // Implementar lógica de reasignación
        console.log('Reasignar entrega:', idEntrega);
        this.mostrarInfo('Funcionalidad de reasignación en desarrollo');
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
                        <td colspan="8" class="text-center">
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

    formatearFechaHora(fechaString) {
        if (!fechaString) return 'N/A';
        const fecha = new Date(fechaString);
        return fecha.toLocaleString('es-ES');
    }

    formatearProductos(items) {
        if (!items) return 'N/A';
        try {
            const productos = typeof items === 'string' ? JSON.parse(items) : items;
            return productos.map(p => `${p.cantidad}x ${p.nombre_producto || 'Producto'}`).join(', ');
        } catch {
            return 'N/A';
        }
    }

    formatearMoneda(monto) {
        return new Intl.NumberFormat('es-MX', {
            style: 'currency',
            currency: 'MXN'
        }).format(monto);
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaEntregas');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="8" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-spinner fa-spin"></i>
                            <span>Cargando entregas...</span>
                        </div>
                    </td>
                </tr>
            `;
        }
    }

    // ==================== AUTENTICACIÓN Y PERMISOS ====================
    esRepartidor() {
        // Esta función debería leer del contexto de la sesión
        // Por ahora, asumimos que está disponible globalmente
        return typeof userRole !== 'undefined' && userRole === 'Repartidor';
    }

    obtenerUserId() {
        // Esta función debería leer del contexto de la sesión
        return typeof userId !== 'undefined' ? userId : null;
    }

    // ==================== NOTIFICACIONES ====================
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
        // Implementar sistema de notificaciones
        console.log(`[${tipo.toUpperCase()}] ${mensaje}`);

        // Notificación simple con alert nativo por ahora
        const colores = {
            success: '#27ae60',
            error: '#e74c3c',
            info: '#3498db',
            warning: '#f39c12'
        };

        // Crear notificación toast simple
        const toast = document.createElement('div');
        toast.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${colores[tipo] || '#3498db'};
            color: white;
            padding: 12px 20px;
            border-radius: 4px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            max-width: 300px;
            word-wrap: break-word;
        `;
        toast.textContent = mensaje;
        document.body.appendChild(toast);

        setTimeout(() => {
            document.body.removeChild(toast);
        }, 5000);
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