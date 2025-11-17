// rutas.js - Gestión de Rutas
class RutasApp {
    constructor() {
        this.rutas = [];
        this.pedidosDisponibles = [];
        this.pedidosSeleccionados = [];
        this.zonas = [];
        this.repartidores = [];
        this.vehiculos = [];
        this.paginaActual = 1;
        this.totalPaginas = 1;
        this.registrosPorPagina = 10;
        this.filtros = {
            estado: '',
            zona: '',
            fecha: ''
        };
        this.rutaSeleccionada = null;
        this.init();
    }

    init() {
        console.log('🛣️ Inicializando módulo de rutas...');
        this.bindEvents();
        this.cargarDatosIniciales();
        this.cargarRutas();
        this.configurarDragAndDrop();
    }

    bindEvents() {
        // Filtros
        document.getElementById('filtroEstado')?.addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
        });

        document.getElementById('filtroZona')?.addEventListener('change', (e) => {
            this.filtros.zona = e.target.value;
        });

        document.getElementById('filtroFecha')?.addEventListener('change', (e) => {
            this.filtros.fecha = e.target.value;
        });

        // Paginación
        document.getElementById('btnAnterior')?.addEventListener('click', () => {
            if (this.paginaActual > 1) {
                this.paginaActual--;
                this.cargarRutas();
            }
        });

        document.getElementById('btnSiguiente')?.addEventListener('click', () => {
            if (this.paginaActual < this.totalPaginas) {
                this.paginaActual++;
                this.cargarRutas();
            }
        });

        // Búsqueda de pedidos
        document.getElementById('buscarPedidos')?.addEventListener('input', (e) => {
            this.filtrarPedidosDisponibles(e.target.value);
        });

        // Fecha actual como predeterminada
        const hoy = new Date();
        document.getElementById('fechaRuta').value = hoy.toISOString().split('T')[0];
    }

    configurarDragAndDrop() {
        // Esta función configuraría el drag and drop para los pedidos
        // Por ahora es un placeholder para la funcionalidad
        console.log('Configurando drag and drop...');
    }

    // ==================== CARGA DE DATOS ====================
    async cargarDatosIniciales() {
        try {
            await Promise.all([
                this.cargarZonas(),
                this.cargarRepartidores(),
                this.cargarVehiculos(),
                this.cargarPedidosDisponibles()
            ]);
        } catch (error) {
            console.error('Error cargando datos iniciales:', error);
            this.mostrarError('Error cargando datos del sistema');
        }
    }

    async cargarRutas() {
        try {
            this.mostrarCargando();

            const params = new URLSearchParams({
                pagina: this.paginaActual,
                limite: this.registrosPorPagina,
                ...this.filtros
            });

            const response = await fetch(`/api/rutas?${params}`, {
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}: ${response.statusText}`);

            const data = await response.json();
            this.rutas = Array.isArray(data) ? data : (data.rutas || []);

            this.totalPaginas = data.totalPaginas || Math.ceil(this.rutas.length / this.registrosPorPagina);

            this.actualizarTabla();
            this.actualizarEstadisticas();
            this.actualizarPaginacion();

        } catch (error) {
            console.error('Error cargando rutas:', error);
            this.mostrarError('Error cargando la lista de rutas: ' + error.message);
        }
    }

    async cargarZonas() {
        try {
            // Datos de ejemplo para desarrollo
            this.zonas = [
                { id_zona: 1, nombre_zona: 'Zona Norte' },
                { id_zona: 2, nombre_zona: 'Zona Sur' },
                { id_zona: 3, nombre_zona: 'Zona Este' },
                { id_zona: 4, nombre_zona: 'Zona Oeste' },
                { id_zona: 5, nombre_zona: 'Zona Centro' }
            ];

            // Llenar selects de zonas
            const selects = ['filtroZona', 'zonaRuta'];
            selects.forEach(selectId => {
                const select = document.getElementById(selectId);
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar zona...</option>' +
                        this.zonas.map(zona =>
                            `<option value="${zona.id_zona}">${zona.nombre_zona}</option>`
                        ).join('');
                }
            });
        } catch (error) {
            console.error('Error cargando zonas:', error);
        }
    }

    async cargarRepartidores() {
        try {
            // Datos de ejemplo para desarrollo
            this.repartidores = [
                { id_usuario: 1, nombre: 'Carlos Rodríguez' },
                { id_usuario: 2, nombre: 'Ana Martínez' },
                { id_usuario: 3, nombre: 'Luis García' },
                { id_usuario: 4, nombre: 'María López' },
                { id_usuario: 5, nombre: 'Pedro Sánchez' }
            ];

            // Llenar selects de repartidores
            const selects = ['repartidorRuta', 'editarRepartidor'];
            selects.forEach(selectId => {
                const select = document.getElementById(selectId);
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar repartidor...</option>' +
                        this.repartidores.map(repartidor =>
                            `<option value="${repartidor.id_usuario}">${repartidor.nombre}</option>`
                        ).join('');
                }
            });
        } catch (error) {
            console.error('Error cargando repartidores:', error);
        }
    }

    async cargarVehiculos() {
        try {
            // Datos de ejemplo para desarrollo
            this.vehiculos = [
                { id_vehiculo: 1, placa: 'ABC123', tipo: 'Camioneta' },
                { id_vehiculo: 2, placa: 'DEF456', tipo: 'Moto' },
                { id_vehiculo: 3, placa: 'GHI789', tipo: 'Camioneta' },
                { id_vehiculo: 4, placa: 'JKL012', tipo: 'Furgoneta' },
                { id_vehiculo: 5, placa: 'MNO345', tipo: 'Moto' }
            ];

            // Llenar selects de vehículos
            const selects = ['vehiculoRuta', 'editarVehiculo'];
            selects.forEach(selectId => {
                const select = document.getElementById(selectId);
                if (select) {
                    select.innerHTML = '<option value="">Seleccionar vehículo...</option>' +
                        this.vehiculos.map(vehiculo =>
                            `<option value="${vehiculo.id_vehiculo}">${vehiculo.placa} - ${vehiculo.tipo}</option>`
                        ).join('');
                }
            });
        } catch (error) {
            console.error('Error cargando vehículos:', error);
        }
    }

    async cargarPedidosDisponibles() {
        try {
            // Simular carga de pedidos disponibles
            this.pedidosDisponibles = [
                {
                    id_pedido: 101,
                    nombre_cliente: 'Juan Pérez',
                    direccion_entrega: 'Av. Principal 123, Zona Norte',
                    total: 150.00
                },
                {
                    id_pedido: 102,
                    nombre_cliente: 'María García',
                    direccion_entrega: 'Calle Secundaria 456, Zona Centro',
                    total: 89.50
                },
                {
                    id_pedido: 103,
                    nombre_cliente: 'Carlos López',
                    direccion_entrega: 'Av. Norte 789, Zona Norte',
                    total: 234.75
                },
                {
                    id_pedido: 104,
                    nombre_cliente: 'Ana Martínez',
                    direccion_entrega: 'Calle Este 321, Zona Este',
                    total: 67.80
                },
                {
                    id_pedido: 105,
                    nombre_cliente: 'Pedro Sánchez',
                    direccion_entrega: 'Av. Sur 654, Zona Sur',
                    total: 189.90
                }
            ];

            this.actualizarListaPedidosDisponibles();
        } catch (error) {
            console.error('Error cargando pedidos disponibles:', error);
        }
    }

    // ==================== RENDERIZADO ====================
    actualizarTabla() {
        const tbody = document.getElementById('tablaRutas');
        if (!tbody) return;

        if (this.rutas.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="10" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-route"></i>
                            <span>No se encontraron rutas</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = this.rutas.map(ruta => `
            <tr>
                <td><strong>#${ruta.id_ruta}</strong></td>
                <td>
                    <strong>${ruta.nombre_ruta || `Ruta ${ruta.id_ruta}`}</strong>
                    ${this.esRutaUrgente(ruta) ? '<span class="badge bg-danger ms-1">Urgente</span>' : ''}
                </td>
                <td>${this.getNombreZona(ruta.id_zona)}</td>
                <td>${this.formatearFecha(ruta.fecha)}</td>
                <td>${this.getNombreRepartidor(ruta.id_repartidor)}</td>
                <td>${this.getPlacaVehiculo(ruta.id_vehiculo)}</td>
                <td>
                    <span class="badge bg-primary">${ruta.total_paradas || 0}</span>
                </td>
                <td>${ruta.distancia_total ? `${ruta.distancia_total} km` : 'N/A'}</td>
                <td>
                    <span class="estado-badge estado-${this.getEstadoSlug(ruta.id_estado_ruta)}">
                        ${this.getEstadoTexto(ruta.id_estado_ruta)}
                    </span>
                </td>
                <td class="acciones-cell">
                    <button class="btn-action btn-view" onclick="rutasApp.verDetalles(${ruta.id_ruta})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    ${this.puedeEditar(ruta) ? `
                        <button class="btn-action btn-edit" onclick="rutasApp.mostrarModalEditar(${ruta.id_ruta})" title="Editar ruta">
                            <i class="fas fa-edit"></i>
                        </button>
                    ` : ''}
                    ${this.puedeEliminar(ruta) ? `
                        <button class="btn-action btn-danger" onclick="rutasApp.eliminarRuta(${ruta.id_ruta})" title="Eliminar ruta">
                            <i class="fas fa-trash"></i>
                        </button>
                    ` : ''}
                </td>
            </tr>
        `).join('');
    }

    actualizarEstadisticas() {
        const total = this.rutas.length;
        const activas = this.rutas.filter(r => r.id_estado_ruta === 2).length;
        const entregasPlanificadas = this.rutas.reduce((sum, ruta) => sum + (ruta.total_paradas || 0), 0);
        const kmTotales = this.rutas.reduce((sum, ruta) => sum + (parseFloat(ruta.distancia_total) || 0), 0);
        const eficienciaPromedio = total > 0 ? Math.round(Math.random() * 30 + 70) : 0; // Simulado

        document.getElementById('totalRutas').textContent = total;
        document.getElementById('rutasActivas').textContent = activas;
        document.getElementById('entregasPlanificadas').textContent = entregasPlanificadas;
        document.getElementById('kmTotales').textContent = `${kmTotales.toFixed(1)} km`;
        document.getElementById('eficienciaPromedio').textContent = `${eficienciaPromedio}%`;
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
        const fin = Math.min(this.paginaActual * this.registrosPorPagina, this.rutas.length);

        if (mostrandoDesde) mostrandoDesde.textContent = inicio;
        if (mostrandoHasta) mostrandoHasta.textContent = fin;
        if (totalRegistros) totalRegistros.textContent = this.rutas.length;

        if (paginationNumbers) {
            paginationNumbers.innerHTML = '';
            for (let i = 1; i <= this.totalPaginas; i++) {
                const btn = document.createElement('button');
                btn.className = `btn-pagination ${i === this.paginaActual ? 'active' : ''}`;
                btn.textContent = i;
                btn.onclick = () => {
                    this.paginaActual = i;
                    this.cargarRutas();
                };
                paginationNumbers.appendChild(btn);
            }
        }
    }

    actualizarListaPedidosDisponibles() {
        const lista = document.getElementById('listaPedidosDisponibles');
        if (!lista) return;

        lista.innerHTML = this.pedidosDisponibles.map(pedido => `
            <div class="pedido-item" data-pedido-id="${pedido.id_pedido}" 
                 onclick="rutasApp.seleccionarPedido(${pedido.id_pedido})">
                <div class="pedido-header">
                    <span class="pedido-id">#${pedido.id_pedido}</span>
                    <span class="badge bg-success">$${pedido.total.toFixed(2)}</span>
                </div>
                <div class="pedido-cliente">${pedido.nombre_cliente}</div>
                <div class="pedido-direccion">${pedido.direccion_entrega}</div>
            </div>
        `).join('');
    }

    actualizarListaPedidosSeleccionados() {
        const lista = document.getElementById('listaPedidosSeleccionados');
        const contador = document.getElementById('contadorPedidos');
        const resumen = document.getElementById('resumenRuta');

        if (!lista) return;

        if (this.pedidosSeleccionados.length === 0) {
            lista.innerHTML = '<div class="text-muted text-center p-3">No hay pedidos seleccionados</div>';
            resumen.style.display = 'none';
        } else {
            lista.innerHTML = this.pedidosSeleccionados.map((pedido, index) => `
                <div class="pedido-item seleccionado" data-pedido-id="${pedido.id_pedido}">
                    <div class="pedido-header">
                        <span class="pedido-id">#${index + 1}. #${pedido.id_pedido}</span>
                        <button type="button" class="btn-remove" onclick="rutasApp.removerPedido(${pedido.id_pedido})">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="pedido-cliente">${pedido.nombre_cliente}</div>
                    <div class="pedido-direccion">${pedido.direccion_entrega}</div>
                </div>
            `).join('');
            resumen.style.display = 'block';
        }

        if (contador) {
            contador.textContent = this.pedidosSeleccionados.length;
            contador.className = `badge ${this.pedidosSeleccionados.length > 0 ? 'bg-primary' : 'bg-secondary'}`;
        }

        this.actualizarResumenRuta();
    }

    actualizarResumenRuta() {
        const totalPedidos = this.pedidosSeleccionados.length;
        const distanciaEstimada = totalPedidos * 2.5; // Simulado: 2.5km por pedido
        const tiempoEstimado = totalPedidos * 15; // Simulado: 15min por pedido
        const eficienciaEstimada = Math.min(95, 70 + (totalPedidos * 2)); // Simulado

        document.getElementById('resumenTotalPedidos').textContent = totalPedidos;
        document.getElementById('resumenDistancia').textContent = `${distanciaEstimada.toFixed(1)} km`;
        document.getElementById('resumenTiempo').textContent = `${tiempoEstimado} min`;
        document.getElementById('resumenEficiencia').textContent = `${eficienciaEstimada}%`;
    }

    // ==================== LÓGICA DE ESTADOS ====================
    esRutaUrgente(ruta) {
        // Una ruta es urgente si está activa y tiene muchas paradas pendientes
        return ruta.id_estado_ruta === 2 && (ruta.paradas_pendientes || 0) > 5;
    }

    puedeEditar(ruta) {
        return ['Admin', 'Planificador'].includes(window.userRole) && ruta.id_estado_ruta === 1;
    }

    puedeEliminar(ruta) {
        return ['Admin', 'Planificador'].includes(window.userRole) && ruta.id_estado_ruta === 1;
    }

    getEstadoSlug(idEstado) {
        const estados = {
            1: 'planificada',
            2: 'activa',
            3: 'completada',
            4: 'cancelada'
        };
        return estados[idEstado] || 'planificada';
    }

    getEstadoTexto(idEstado) {
        const estados = {
            1: 'Planificada',
            2: 'Activa',
            3: 'Completada',
            4: 'Cancelada'
        };
        return estados[idEstado] || 'Desconocido';
    }

    getNombreZona(idZona) {
        const zona = this.zonas.find(z => z.id_zona == idZona);
        return zona ? zona.nombre_zona : `Zona ${idZona}`;
    }

    getNombreRepartidor(idRepartidor) {
        const repartidor = this.repartidores.find(r => r.id_usuario == idRepartidor);
        return repartidor ? repartidor.nombre : 'No asignado';
    }

    getPlacaVehiculo(idVehiculo) {
        const vehiculo = this.vehiculos.find(v => v.id_vehiculo == idVehiculo);
        return vehiculo ? vehiculo.placa : 'No asignado';
    }

    // ==================== MODALES ====================
    mostrarModalCrearRuta() {
        this.cerrarTodosModales();
        this.pedidosSeleccionados = []; // Reiniciar selección
        this.actualizarListaPedidosSeleccionados();
        document.getElementById('modalCrearRuta').style.display = 'block';
    }

    cerrarModalCrear() {
        document.getElementById('modalCrearRuta').style.display = 'none';
        document.getElementById('formCrearRuta').reset();
        this.pedidosSeleccionados = [];
    }

    async verDetalles(idRuta) {
        this.rutaSeleccionada = idRuta;

        try {
            const response = await fetch(`/api/rutas/${idRuta}`);
            if (response.ok) {
                const ruta = await response.json();
                this.mostrarModalDetalles(ruta);
            } else {
                // Buscar en datos locales
                const ruta = this.rutas.find(r => r.id_ruta == idRuta);
                if (ruta) {
                    this.mostrarModalDetalles(ruta);
                } else {
                    throw new Error('Ruta no encontrada');
                }
            }
        } catch (error) {
            console.error('Error cargando detalles:', error);
            this.mostrarError('Error al cargar los detalles de la ruta');
        }
    }

    mostrarModalDetalles(ruta) {
        document.getElementById('detalleNombreRuta').textContent = ruta.nombre_ruta || `Ruta ${ruta.id_ruta}`;
        document.getElementById('detalleEstadoRuta').textContent = this.getEstadoTexto(ruta.id_estado_ruta);
        document.getElementById('detalleEstadoRuta').className = `estado-badge estado-${this.getEstadoSlug(ruta.id_estado_ruta)}`;
        document.getElementById('detalleFechaRuta').textContent = this.formatearFecha(ruta.fecha);
        document.getElementById('detalleTotalParadas').textContent = ruta.total_paradas || 0;
        document.getElementById('detalleDistancia').textContent = ruta.distancia_total ? `${ruta.distancia_total} km` : 'N/A';
        document.getElementById('detalleEficiencia').textContent = ruta.eficiencia ? `${ruta.eficiencia}%` : 'N/A';
        document.getElementById('detalleRepartidor').textContent = this.getNombreRepartidor(ruta.id_repartidor);
        document.getElementById('detalleVehiculo').textContent = this.getPlacaVehiculo(ruta.id_vehiculo);
        document.getElementById('detalleZona').textContent = this.getNombreZona(ruta.id_zona);
        document.getElementById('detalleHoraInicio').textContent = ruta.hora_inicio || 'No especificada';

        // Cargar paradas de la ruta
        this.cargarParadasRuta(ruta.id_ruta);

        this.cerrarTodosModales();
        document.getElementById('modalDetallesRuta').style.display = 'block';
    }

    cerrarModalDetalles() {
        document.getElementById('modalDetallesRuta').style.display = 'none';
        this.rutaSeleccionada = null;
    }

    async mostrarModalEditar(idRuta) {
        this.rutaSeleccionada = idRuta;

        try {
            const response = await fetch(`/api/rutas/${idRuta}`);
            if (response.ok) {
                const ruta = await response.json();
                document.getElementById('rutaIdEditar').value = idRuta;
                document.getElementById('editarNombreRuta').value = ruta.nombre_ruta || '';
                document.getElementById('editarEstadoRuta').value = ruta.id_estado_ruta;
                document.getElementById('editarRepartidor').value = ruta.id_repartidor || '';
                document.getElementById('editarVehiculo').value = ruta.id_vehiculo || '';
            }
        } catch (error) {
            console.error('Error cargando datos para editar:', error);
        }

        this.cerrarTodosModales();
        document.getElementById('modalEditarRuta').style.display = 'block';
    }

    cerrarModalEditar() {
        document.getElementById('modalEditarRuta').style.display = 'none';
        document.getElementById('formEditarRuta').reset();
        this.rutaSeleccionada = null;
    }

    cerrarTodosModales() {
        document.querySelectorAll('.modal').forEach(modal => {
            modal.style.display = 'none';
        });
    }

    // ==================== GESTIÓN DE PEDIDOS ====================
    seleccionarPedido(idPedido) {
        const pedido = this.pedidosDisponibles.find(p => p.id_pedido === idPedido);
        if (pedido && !this.pedidosSeleccionados.find(p => p.id_pedido === idPedido)) {
            this.pedidosSeleccionados.push(pedido);
            this.actualizarListaPedidosSeleccionados();
        }
    }

    removerPedido(idPedido) {
        this.pedidosSeleccionados = this.pedidosSeleccionados.filter(p => p.id_pedido !== idPedido);
        this.actualizarListaPedidosSeleccionados();
    }

    filtrarPedidosDisponibles(termino) {
        const lista = document.getElementById('listaPedidosDisponibles');
        if (!lista) return;

        const terminoLower = termino.toLowerCase();
        const pedidosFiltrados = this.pedidosDisponibles.filter(pedido =>
            pedido.id_pedido.toString().includes(termino) ||
            pedido.nombre_cliente.toLowerCase().includes(terminoLower) ||
            pedido.direccion_entrega.toLowerCase().includes(terminoLower)
        );

        lista.innerHTML = pedidosFiltrados.map(pedido => `
            <div class="pedido-item" data-pedido-id="${pedido.id_pedido}" 
                 onclick="rutasApp.seleccionarPedido(${pedido.id_pedido})">
                <div class="pedido-header">
                    <span class="pedido-id">#${pedido.id_pedido}</span>
                    <span class="badge bg-success">$${pedido.total.toFixed(2)}</span>
                </div>
                <div class="pedido-cliente">${pedido.nombre_cliente}</div>
                <div class="pedido-direccion">${pedido.direccion_entrega}</div>
            </div>
        `).join('');
    }

    // ==================== ACCIONES ====================
    async crearRuta() {
        const form = document.getElementById('formCrearRuta');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        if (this.pedidosSeleccionados.length === 0) {
            this.mostrarError('Debe seleccionar al menos un pedido para la ruta');
            return;
        }

        const formData = new FormData(form);
        const data = {
            zona_id: parseInt(formData.get('zonaRuta')),
            fecha: formData.get('fechaRuta'),
            secuencia_json: JSON.stringify(this.pedidosSeleccionados.map(pedido => ({
                pedido_id: pedido.id_pedido,
                orden: this.pedidosSeleccionados.indexOf(pedido) + 1
            }))),
            nombre_ruta: formData.get('nombreRuta'),
            id_repartidor: parseInt(formData.get('repartidorRuta')),
            id_vehiculo: parseInt(formData.get('vehiculoRuta')),
            id_estado_ruta: parseInt(formData.get('estadoRuta'))
        };

        try {
            const response = await fetch('/api/rutas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) throw new Error('Error creando ruta');

            this.mostrarExito('Ruta creada correctamente');
            this.cerrarModalCrear();
            this.cargarRutas();

        } catch (error) {
            console.error('Error creando ruta:', error);
            this.mostrarError('Error al crear la ruta: ' + error.message);
        }
    }

    async actualizarRuta() {
        const form = document.getElementById('formEditarRuta');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const formData = new FormData(form);
        const data = {
            nombre_ruta: formData.get('editarNombreRuta'),
            id_estado_ruta: parseInt(formData.get('editarEstadoRuta')),
            id_repartidor: parseInt(formData.get('editarRepartidor')) || null,
            id_vehiculo: parseInt(formData.get('editarVehiculo')) || null
        };

        try {
            const response = await fetch(`/api/rutas/${this.rutaSeleccionada}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) throw new Error('Error actualizando ruta');

            this.mostrarExito('Ruta actualizada correctamente');
            this.cerrarModalEditar();
            this.cargarRutas();

        } catch (error) {
            console.error('Error actualizando ruta:', error);
            this.mostrarError('Error al actualizar la ruta: ' + error.message);
        }
    }

    async eliminarRuta(idRuta) {
        if (!confirm('¿Está seguro de que desea eliminar esta ruta? Esta acción no se puede deshacer.')) {
            return;
        }

        try {
            const response = await fetch(`/api/rutas/${idRuta}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error('Error eliminando ruta');

            this.mostrarExito('Ruta eliminada correctamente');
            this.cargarRutas();

        } catch (error) {
            console.error('Error eliminando ruta:', error);
            this.mostrarError('Error al eliminar la ruta: ' + error.message);
        }
    }

    async iniciarRuta() {
        if (!this.rutaSeleccionada) return;

        try {
            // Simular inicio de ruta
            console.log('Iniciando ruta:', this.rutaSeleccionada);

            this.mostrarExito('Ruta iniciada correctamente');
            this.cerrarModalDetalles();
            this.cargarRutas();

        } catch (error) {
            console.error('Error iniciando ruta:', error);
            this.mostrarError('Error al iniciar la ruta: ' + error.message);
        }
    }

    async cargarParadasRuta(idRuta) {
        try {
            const response = await fetch(`/api/rutas/${idRuta}/paradas`);
            let paradas = [];

            if (response.ok) {
                paradas = await response.json();
            } else {
                // Datos de ejemplo
                paradas = this.pedidosSeleccionados.map((pedido, index) => ({
                    orden: index + 1,
                    nombre_cliente: pedido.nombre_cliente,
                    direccion_entrega: pedido.direccion_entrega,
                    estado: index === 0 ? 'En curso' : 'Pendiente'
                }));
            }

            this.actualizarListaParadas(paradas);
        } catch (error) {
            console.error('Error cargando paradas:', error);
        }
    }

    actualizarListaParadas(paradas) {
        const lista = document.getElementById('listaParadas');
        if (!lista) return;

        if (paradas.length === 0) {
            lista.innerHTML = '<div class="text-muted text-center p-3">No hay paradas definidas</div>';
            return;
        }

        lista.innerHTML = paradas.map(parada => `
            <div class="parada-item">
                <div class="parada-orden">${parada.orden}</div>
                <div class="parada-info">
                    <div class="parada-cliente">${parada.nombre_cliente}</div>
                    <div class="parada-direccion">${parada.direccion_entrega}</div>
                </div>
                <div class="parada-estado ${parada.estado === 'Completada' ? 'completada' : 'pendiente'}">
                    ${parada.estado}
                </div>
            </div>
        `).join('');
    }

    // ==================== UTILIDADES ====================
    aplicarFiltros() {
        this.paginaActual = 1;
        this.cargarRutas();
    }

    actualizarMapa() {
        this.mostrarInfo('Mapa actualizado');
    }

    mostrarTodasRutas() {
        this.mostrarInfo('Mostrando todas las rutas en el mapa');
    }

    formatearFecha(fechaString) {
        if (!fechaString) return 'N/A';
        try {
            const fecha = new Date(fechaString);
            return fecha.toLocaleDateString('es-ES');
        } catch (e) {
            return 'N/A';
        }
    }

    mostrarCargando() {
        const tbody = document.getElementById('tablaRutas');
        if (tbody) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="10" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-spinner fa-spin"></i>
                            <span>Cargando rutas...</span>
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
    window.rutasApp = new RutasApp();
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