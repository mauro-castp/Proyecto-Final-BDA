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

    usarPedidosEjemplo() {
        console.log("🔄 Usando datos de ejemplo para pedidos...");
        this.pedidosDisponibles = [
            {
                id_pedido: 1001,
                nombre_cliente: "Cliente Ejemplo 1",
                direccion_entrega: "Av. Principal #123, Zona Norte",
                total: 150.75,
                fecha_pedido: "2025-11-24 10:30:00",
                estado_pedido: "Pendiente",
                peso_total: 2.5,
                volumen_total: 0.5
            },
            {
                id_pedido: 1002,
                nombre_cliente: "Cliente Ejemplo 2",
                direccion_entrega: "Calle Secundaria #456, Zona Centro",
                total: 89.50,
                fecha_pedido: "2025-11-24 11:15:00",
                estado_pedido: "Confirmado",
                peso_total: 1.2,
                volumen_total: 0.3
            },
            {
                id_pedido: 1003,
                nombre_cliente: "Cliente Ejemplo 3",
                direccion_entrega: "Plaza Central #789, Zona Sur",
                total: 245.30,
                fecha_pedido: "2025-11-24 09:45:00",
                estado_pedido: "Pendiente",
                peso_total: 5.0,
                volumen_total: 1.2
            }
        ];

        this.actualizarListaPedidosDisponibles();
        // this.mostrarInfo("Usando datos de ejemplo para desarrollo");
    }

    init() {
        console.log('🛣️ Inicializando módulo de rutas...');
        this.configurarEventosModales();
        this.bindEvents();
        this.cargarDatosIniciales();
        this.cargarRutas();
        this.configurarDragAndDrop();
    }

    configurarEventosModales() {
        // Cerrar modales con ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.cerrarTodosModales();
            }
        });

        // Prevenir cierre al hacer click dentro del modal
        document.querySelectorAll('.modal-content').forEach(modalContent => {
            modalContent.addEventListener('click', (e) => {
                e.stopPropagation();
            });
        });
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
                estado: this.filtros.estado,
                zona: this.filtros.zona,
                fecha: this.filtros.fecha
            });

            const response = await fetch(`/api/rutas?${params}`);

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || `HTTP ${response.status}: ${response.statusText}`);
            }

            const data = await response.json();
            this.rutas = data.rutas || [];

            this.totalPaginas = data.paginacion?.total_paginas ||
                Math.ceil((data.paginacion?.total_registros || this.rutas.length) / this.registrosPorPagina);

            this.actualizarTabla();
            this.actualizarEstadisticas();
            this.actualizarPaginacion(data.paginacion);

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
            console.log('🔄 Cargando pedidos disponibles...');

            const response = await fetch('/api/pedidos/disponibles');

            if (response.ok) {
                const pedidos = await response.json();
                console.log('📦 Pedidos cargados del backend:', pedidos);

                this.pedidosDisponibles = pedidos;
            } else {
                console.error('❌ Error del servidor al cargar pedidos:', response.status);
                // Usar datos de ejemplo como fallback
                this.usarPedidosEjemplo();
            }

            this.actualizarListaPedidosDisponibles();

        } catch (error) {
            console.error('💥 Error cargando pedidos disponibles:', error);
            this.usarPedidosEjemplo();
        }
    }

    // ==================== RENDERIZADO ====================
    actualizarTabla() {
        const tbody = document.getElementById('tablaRutas');
        if (!tbody) {
            console.error('❌ No se encontró el tbody con id "tablaRutas"');
            return;
        }

        console.log('📊 Datos de rutas recibidos:', this.rutas);

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
                <td>
                    <strong>${ruta.nombre_ruta || 'Sin nombre'}</strong>
                    ${this.esRutaUrgente(ruta) ? '<span class="badge bg-danger ms-1">Urgente</span>' : ''}
                </td>
                <td>${ruta.nombre_zona || this.getNombreZona(ruta.id_zona)}</td>
                <td>${this.formatearFecha(ruta.fecha || ruta.fecha_ruta)}</td>
                <td>${ruta.nombre_repartidor || this.getNombreRepartidor(ruta.id_repartidor)}</td>
                <td>${ruta.placa || this.getPlacaVehiculo(ruta.id_vehiculo)}</td>
                <td>
                    <span class="badge bg-primary">${ruta.total_paradas || 0}</span>
                </td>
                <td>${ruta.distancia_total ? `${ruta.distancia_total} km` :
                ruta.distancia_total_km ? `${ruta.distancia_total_km} km` : 'N/A'}</td>
                <td>
                    <span class="estado-badge estado-${this.getEstadoSlug(ruta.id_estado_ruta)}">
                        ${ruta.nombre_estado || this.getEstadoTexto(ruta.id_estado_ruta)}
                    </span>
                </td>
                <td class="acciones-cell">
                    <!-- MOSTRAR TODOS LOS BOTONES SIEMPRE - EL BACKEND MANEJA LOS PERMISOS -->
                    <button class="btn-action btn-view" onclick="rutasApp.verDetalles(${ruta.id_ruta})" title="Ver detalles">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn-action btn-edit" onclick="rutasApp.mostrarModalEditar(${ruta.id_ruta})" title="Editar ruta">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn-action btn-danger" onclick="rutasApp.eliminarRuta(${ruta.id_ruta})" title="Eliminar ruta">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `).join('');

        console.log('✅ Tabla actualizada con', this.rutas.length, 'rutas');
    }

    actualizarEstadisticas() {
        const total = this.rutas.length;
        const activas = this.rutas.filter(r => r.id_estado_ruta === 2).length;
        const entregasPlanificadas = this.rutas.reduce((sum, ruta) => sum + (ruta.total_paradas || 0), 0);
        const kmTotales = this.rutas.reduce((sum, ruta) => sum + (parseFloat(ruta.distancia_total) || 0), 0);
        const eficienciaPromedio = total > 0 ? Math.round(Math.random() * 30 + 70) : 0;

        document.getElementById('totalRutas').textContent = total;
        document.getElementById('rutasActivas').textContent = activas;
        document.getElementById('entregasPlanificadas').textContent = entregasPlanificadas;
        document.getElementById('kmTotales').textContent = `${kmTotales.toFixed(1)} km`;
        document.getElementById('eficienciaPromedio').textContent = `${eficienciaPromedio}%`;
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

        const totalRegistrosCount = paginacion?.total_registros || this.rutas.length;
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
                    this.cargarRutas();
                };
                paginationNumbers.appendChild(btn);
            }
        }
    }

    actualizarListaPedidosDisponibles() {
        const lista = document.getElementById('listaPedidosDisponibles');
        if (!lista) return;

        // Mostrar loading
        lista.innerHTML = `
            <div class="text-center p-3">
                <i class="fas fa-spinner fa-spin"></i>
                <span>Cargando pedidos disponibles...</span>
            </div>
        `;

        // Simular delay para ver el loading (opcional)
        setTimeout(() => {
            if (this.pedidosDisponibles.length === 0) {
                lista.innerHTML = `
                    <div class="text-muted text-center p-3">
                        <i class="fas fa-box-open"></i>
                        <p>No hay pedidos disponibles</p>
                        <small>Verifique que existan pedidos pendientes en el sistema</small>
                    </div>
                `;
            } else {
                lista.innerHTML = this.pedidosDisponibles.map(pedido => `
                    <div class="pedido-item" data-pedido-id="${pedido.id_pedido}" 
                         onclick="rutasApp.seleccionarPedido(${pedido.id_pedido})">
                        <div class="pedido-header">
                            <span class="pedido-id">#${pedido.id_pedido}</span>
                            <span class="badge bg-success">$${pedido.total?.toFixed(2) || '0.00'}</span>
                        </div>
                        <div class="pedido-cliente">${pedido.nombre_cliente || 'Cliente'}</div>
                        <div class="pedido-direccion">${pedido.direccion_entrega || 'Dirección no especificada'}</div>
                        ${pedido.fecha_pedido ? `<div class="pedido-fecha"><small>${pedido.fecha_pedido}</small></div>` : ''}
                    </div>
                `).join('');
            }
        }, 500);
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
        const distanciaEstimada = totalPedidos * 2.5;
        const tiempoEstimado = totalPedidos * 15;
        const eficienciaEstimada = Math.min(95, 70 + (totalPedidos * 2));

        document.getElementById('resumenTotalPedidos').textContent = totalPedidos;
        document.getElementById('resumenDistancia').textContent = `${distanciaEstimada.toFixed(1)} km`;
        document.getElementById('resumenTiempo').textContent = `${tiempoEstimado} min`;
        document.getElementById('resumenEficiencia').textContent = `${eficienciaEstimada}%`;
    }

    // ==================== LÓGICA DE ESTADOS ====================
    esRutaUrgente(ruta) {
        return ruta.id_estado_ruta === 2 && (ruta.paradas_pendientes || 0) > 5;
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

    getNombreZona(idZona) {
        if (!idZona) return 'No asignada';
        const zona = this.zonas.find(z => z.id_zona == idZona);
        return zona ? zona.nombre_zona : `Zona ${idZona}`;
    }

    getNombreRepartidor(idRepartidor) {
        if (!idRepartidor) return 'No asignado';
        const repartidor = this.repartidores.find(r => r.id_usuario == idRepartidor);
        return repartidor ? repartidor.nombre : `Repartidor ${idRepartidor}`;
    }

    getPlacaVehiculo(idVehiculo) {
        if (!idVehiculo) return 'No asignado';
        const vehiculo = this.vehiculos.find(v => v.id_vehiculo == idVehiculo);
        return vehiculo ? `${vehiculo.placa} - ${vehiculo.tipo}` : `Vehículo ${idVehiculo}`;
    }

    getEstadoTexto(idEstado) {
        const estados = {
            1: 'por-aprobar',
            2: 'aprobada',
            3: 'en-uso',
            4: 'sin-servicio'
        };
        return estados[idEstado] || 'por-aprobar';
    }

    // ==================== MODALES ====================
    mostrarModalCrearRuta() {
        this.cerrarTodosModales();
        this.pedidosSeleccionados = [];

        // Forzar carga de pedidos disponibles
        this.cargarPedidosDisponibles();

        this.actualizarListaPedidosSeleccionados();
        document.getElementById('modalCrearRuta').style.display = 'block';
    }

    cerrarModalCrear() {
        document.getElementById('modalCrearRuta').style.display = 'none';
        document.getElementById('formCrearRuta').reset();
        this.pedidosSeleccionados = [];
        this.ocultarCargandoModal();
    }

    async verDetalles(idRuta) {
        this.rutaSeleccionada = idRuta;

        try {
            const response = await fetch(`/api/rutas/${idRuta}`);
            if (response.ok) {
                const ruta = await response.json();
                this.mostrarModalDetalles(ruta);
            } else {
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
        document.getElementById('detalleEstadoRuta').textContent = ruta.nombre_estado || this.getEstadoTexto(ruta.id_estado_ruta);
        document.getElementById('detalleEstadoRuta').className = `estado-badge estado-${this.getEstadoSlug(ruta.id_estado_ruta)}`;
        document.getElementById('detalleFechaRuta').textContent = this.formatearFecha(ruta.fecha_ruta);
        document.getElementById('detalleTotalParadas').textContent = ruta.total_paradas || 0;
        document.getElementById('detalleDistancia').textContent = ruta.distancia_total_km ? `${ruta.distancia_total_km} km` : 'N/A';
        document.getElementById('detalleEficiencia').textContent = ruta.eficiencia ? `${ruta.eficiencia}%` : 'N/A';
        document.getElementById('detalleRepartidor').textContent = ruta.nombre_repartidor || 'No asignado';
        document.getElementById('detalleVehiculo').textContent = ruta.placa ? `${ruta.placa} - ${ruta.tipo_vehiculo}` : 'No asignado';
        document.getElementById('detalleZona').textContent = ruta.nombre_zona || 'N/A';
        document.getElementById('detalleHoraInicio').textContent = ruta.hora_inicio || 'No especificada';

        this.actualizarListaParadas(ruta.paradas || []);
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

                console.log('📝 Datos de ruta para editar:', ruta);

                // Llenar el formulario con los datos actuales
                document.getElementById('rutaIdEditar').value = idRuta;
                document.getElementById('editarNombreRuta').value = ruta.nombre_ruta || '';
                document.getElementById('editarEstadoRuta').value = ruta.id_estado_ruta || 1;
                document.getElementById('editarRepartidor').value = ruta.id_repartidor || '';
                document.getElementById('editarVehiculo').value = ruta.id_vehiculo || '';

                this.cerrarTodosModales();
                document.getElementById('modalEditarRuta').style.display = 'block';

            } else {
                throw new Error('Error al cargar datos de la ruta');
            }
        } catch (error) {
            console.error('Error cargando datos para editar:', error);
            this.mostrarError('Error al cargar datos de la ruta: ' + error.message);
        }
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
        try {
            const form = document.getElementById('formCrearRuta');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            // Los pedidos ahora son opcionales - no mostrar error si no hay pedidos seleccionados
            const data = {
                nombre_ruta: document.getElementById('nombreRuta').value,
                id_zona: parseInt(document.getElementById('zonaRuta').value),
                fecha: document.getElementById('fechaRuta').value,
                id_vehiculo: parseInt(document.getElementById('vehiculoRuta').value),
                id_repartidor: parseInt(document.getElementById('repartidorRuta').value),
                pedidos: this.pedidosSeleccionados.map((pedido, index) => ({
                    id_pedido: pedido.id_pedido,
                    orden: index + 1
                }))
            };

            console.log('📤 Enviando datos para crear ruta:', data);
            this.mostrarCargandoModal();

            const response = await fetch('/api/rutas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error al crear la ruta');
            }

            this.mostrarExito('✅ Ruta creada correctamente');
            this.cerrarModalCrear();
            this.cargarRutas();

        } catch (error) {
            console.error('❌ Error creando ruta:', error);
            this.mostrarError('Error al crear la ruta: ' + error.message);
            this.ocultarCargandoModal();
        }
    }

    mostrarCargandoModal() {
        const btnCrear = document.querySelector('#modalCrearRuta .btn-primary');
        if (btnCrear) {
            btnCrear.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creando...';
            btnCrear.disabled = true;
        }
    }

    ocultarCargandoModal() {
        const btnCrear = document.querySelector('#modalCrearRuta .btn-primary');
        if (btnCrear) {
            btnCrear.innerHTML = '<i class="fas fa-save"></i> Crear Ruta';
            btnCrear.disabled = false;
        }
    }

    async actualizarRuta() {
        try {
            const form = document.getElementById('formEditarRuta');
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const rutaId = document.getElementById('rutaIdEditar').value;
            if (!rutaId) {
                this.mostrarError('ID de ruta no válido');
                return;
            }

            const data = {
                nombre_ruta: document.getElementById('editarNombreRuta').value,
                id_estado_ruta: parseInt(document.getElementById('editarEstadoRuta').value),
                id_repartidor: parseInt(document.getElementById('editarRepartidor').value) || null,
                id_vehiculo: parseInt(document.getElementById('editarVehiculo').value) || null
            };

            console.log('📤 Actualizando ruta:', rutaId, data);

            const btnActualizar = document.querySelector('#modalEditarRuta .btn-primary');
            if (btnActualizar) {
                btnActualizar.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Actualizando...';
                btnActualizar.disabled = true;
            }

            const response = await fetch(`/api/rutas/${rutaId}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error al actualizar la ruta');
            }

            this.mostrarExito('✅ Ruta actualizada correctamente');
            this.cerrarModalEditar();
            this.cargarRutas();

        } catch (error) {
            console.error('❌ Error actualizando ruta:', error);
            this.mostrarError('Error al actualizar la ruta: ' + error.message);

            const btnActualizar = document.querySelector('#modalEditarRuta .btn-primary');
            if (btnActualizar) {
                btnActualizar.innerHTML = '<i class="fas fa-check"></i> Actualizar Ruta';
                btnActualizar.disabled = false;
            }
        }
    }

    async eliminarRuta(idRuta) {
        try {
            const confirmacion = await this.mostrarConfirmacion(
                '¿Está seguro de eliminar esta ruta?',
                'Esta acción no se puede deshacer. Se eliminarán todas las paradas asociadas.',
                'warning',
                'Sí, eliminar',
                'Cancelar'
            );

            if (!confirmacion) {
                return;
            }

            console.log('🗑️ Eliminando ruta:', idRuta);

            const response = await fetch(`/api/rutas/${idRuta}`, {
                method: 'DELETE'
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error al eliminar la ruta');
            }

            this.mostrarExito('✅ Ruta eliminada correctamente');
            this.cargarRutas();

        } catch (error) {
            console.error('❌ Error eliminando ruta:', error);
            this.mostrarError('Error al eliminar la ruta: ' + error.message);
        }
    }

    mostrarConfirmacion(titulo, texto, icono, confirmButtonText, cancelButtonText) {
        return new Promise((resolve) => {
            if (typeof Swal !== 'undefined') {
                Swal.fire({
                    title: titulo,
                    text: texto,
                    icon: icono,
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: confirmButtonText,
                    cancelButtonText: cancelButtonText
                }).then((result) => {
                    resolve(result.isConfirmed);
                });
            } else {
                resolve(confirm(titulo + '\n\n' + texto));
            }
        });
    }

    async iniciarRuta(idRuta = null) {
        try {
            const rutaId = idRuta || this.rutaSeleccionada;
            if (!rutaId) {
                this.mostrarError('No se ha seleccionado una ruta');
                return;
            }

            const confirmacion = await this.mostrarConfirmacion(
                'Iniciar Ruta',
                '¿Está seguro de iniciar esta ruta? El estado cambiará a "Activa".',
                'question',
                'Sí, iniciar',
                'Cancelar'
            );

            if (!confirmacion) return;

            const response = await fetch(`/api/rutas/${rutaId}/iniciar`, {
                method: 'POST'
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error al iniciar la ruta');
            }

            this.mostrarExito('✅ Ruta iniciada correctamente');
            this.cerrarModalDetalles();
            this.cargarRutas();

        } catch (error) {
            console.error('❌ Error iniciando ruta:', error);
            this.mostrarError('Error al iniciar la ruta: ' + error.message);
        }
    }

    async completarRuta(idRuta = null) {
        try {
            const rutaId = idRuta || this.rutaSeleccionada;
            if (!rutaId) {
                this.mostrarError('No se ha seleccionado una ruta');
                return;
            }

            const confirmacion = await this.mostrarConfirmacion(
                'Completar Ruta',
                '¿Está seguro de marcar esta ruta como completada?',
                'question',
                'Sí, completar',
                'Cancelar'
            );

            if (!confirmacion) return;

            const response = await fetch(`/api/rutas/${rutaId}/completar`, {
                method: 'POST'
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.error || 'Error al completar la ruta');
            }

            this.mostrarExito('✅ Ruta completada correctamente');
            this.cerrarModalDetalles();
            this.cargarRutas();

        } catch (error) {
            console.error('❌ Error completando ruta:', error);
            this.mostrarError('Error al completar la ruta: ' + error.message);
        }
    }

    async cargarParadasRuta(idRuta) {
        try {
            const response = await fetch(`/api/rutas/${idRuta}/paradas`);
            let paradas = [];

            if (response.ok) {
                paradas = await response.json();
            } else {
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
                <div class="parada-orden">${parada.orden_secuencia}</div>
                <div class="parada-info">
                    <div class="parada-cliente">${parada.nombre_cliente}</div>
                    <div class="parada-direccion">${parada.direccion}</div>
                    <div class="parada-pedido">Pedido #${parada.id_pedido}</div>
                </div>
                <div class="parada-estado ${parada.estado_parada === 'Completada' ? 'completada' :
                parada.estado_parada === 'En curso' ? 'en-curso' : 'pendiente'}">
                    ${parada.estado_parada || 'Pendiente'}
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
            let fecha;

            if (fechaString.includes('T')) {
                fecha = new Date(fechaString);
            } else if (fechaString.includes('-')) {
                fecha = new Date(fechaString + 'T00:00:00');
            } else {
                return 'N/A';
            }

            if (isNaN(fecha.getTime())) {
                return 'N/A';
            }

            return fecha.toLocaleDateString('es-ES', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit'
            });
        } catch (e) {
            console.error('Error formateando fecha:', e, fechaString);
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
        console.log(`[${tipo.toUpperCase()}] ${mensaje}`);

        if (tipo === 'error') {
            alert(`❌ ${mensaje}`);
        } else if (tipo === 'success') {
            alert(`✅ ${mensaje}`);
        } else {
            alert(`ℹ️ ${mensaje}`);
        }
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