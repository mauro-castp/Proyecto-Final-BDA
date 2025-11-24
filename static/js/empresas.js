// static/js/empresas.js
const companiesApp = {
    empresas: [],
    empresaEditando: null,
    filtros: {
        estado: '',
        busqueda: ''
    },
    paginacion: {
        paginaActual: 1,
        elementosPorPagina: 10,
        totalPaginas: 0,
        totalElementos: 0
    },

    init: function() {
        this.cargarEmpresas();
        this.configurarEventos();
    },

    configurarEventos: function() {
        // Eventos de filtros
        document.getElementById('filtroEstado').addEventListener('change', (e) => {
            this.filtros.estado = e.target.value;
            this.aplicarFiltros();
        });

        document.getElementById('filtroBusqueda').addEventListener('input', (e) => {
            this.filtros.busqueda = e.target.value;
            this.aplicarFiltros();
        });

        // Eventos de paginación
        document.getElementById('btnAnterior').addEventListener('click', () => this.paginaAnterior());
        document.getElementById('btnSiguiente').addEventListener('click', () => this.paginaSiguiente());
    },

    cargarEmpresas: async function() {
        try {
            this.mostrarLoading(true);
            
            const response = await fetch('/api/empresas');
            if (!response.ok) throw new Error('Error al cargar empresas');
            
            this.empresas = await response.json();
            this.cargarEstadisticas();
            this.mostrarEmpresas();
            
        } catch (error) {
            console.error('Error:', error);
            this.mostrarError('No se pudieron cargar las empresas');
        } finally {
            this.mostrarLoading(false);
        }
    },

    cargarEstadisticas: async function() {
        try {
            const response = await fetch('/api/empresas/estadisticas');
            if (response.ok) {
                const stats = await response.json();
                this.actualizarEstadisticas(stats);
            }
        } catch (error) {
            console.error('Error cargando estadísticas:', error);
        }
    },

    actualizarEstadisticas: function(stats) {
        document.getElementById('totalEmpresas').textContent = stats.total_empresas || 0;
        document.getElementById('empresasActivas').textContent = stats.empresas_activas || 0;
        document.getElementById('empresasInactivas').textContent = stats.empresas_inactivas || 0;
        document.getElementById('empresasSuspendidas').textContent = stats.empresas_suspendidas || 0;
    },

    aplicarFiltros: function() {
        this.paginacion.paginaActual = 1;
        this.mostrarEmpresas();
    },

    mostrarEmpresas: function() {
        let empresasFiltradas = this.filtrarEmpresas();
        this.paginacion.totalElementos = empresasFiltradas.length;
        this.paginacion.totalPaginas = Math.ceil(empresasFiltradas.length / this.paginacion.elementosPorPagina);
        
        const inicio = (this.paginacion.paginaActual - 1) * this.paginacion.elementosPorPagina;
        const fin = inicio + this.paginacion.elementosPorPagina;
        const empresasPagina = empresasFiltradas.slice(inicio, fin);
        
        this.renderizarEmpresas(empresasPagina);
        this.actualizarPaginacion();
        this.actualizarInfoPaginacion(inicio, fin);
    },

    filtrarEmpresas: function() {
        return this.empresas.filter(empresa => {
            const coincideEstado = !this.filtros.estado || empresa.nombre_estado.toLowerCase() === this.filtros.estado.toLowerCase();
            const coincideBusqueda = !this.filtros.busqueda || 
                empresa.nombre.toLowerCase().includes(this.filtros.busqueda.toLowerCase()) ||
                (empresa.email && empresa.email.toLowerCase().includes(this.filtros.busqueda.toLowerCase())) ||
                (empresa.telefono && empresa.telefono.includes(this.filtros.busqueda));
            
            return coincideEstado && coincideBusqueda;
        });
    },

    renderizarEmpresas: function(empresas) {
        const tbody = document.getElementById('tablaEmpresas');
        
        if (empresas.length === 0) {
            tbody.innerHTML = `
                <tr>
                    <td colspan="7" class="text-center">
                        <div class="loading-spinner">
                            <i class="fas fa-search"></i>
                            <span>No se encontraron empresas</span>
                        </div>
                    </td>
                </tr>
            `;
            return;
        }

        tbody.innerHTML = empresas.map(empresa => `
            <tr>
                <td>
                    <strong>${this.escapeHtml(empresa.nombre)}</strong>
                </td>
                <td>${empresa.telefono || '-'}</td>
                <td>${empresa.email || '-'}</td>
                <td>
                    <span class="direccion-truncada" title="${this.escapeHtml(empresa.direccion || '')}">
                        ${this.escapeHtml(empresa.direccion) || '-'}
                    </span>
                </td>
                <td>
                    <span class="estado-badge estado-${empresa.nombre_estado.toLowerCase()}">
                        ${empresa.nombre_estado}
                    </span>
                </td>
                <td>${new Date(empresa.fecha_creacion).toLocaleDateString()}</td>
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
    },

    actualizarPaginacion: function() {
        const btnAnterior = document.getElementById('btnAnterior');
        const btnSiguiente = document.getElementById('btnSiguiente');
        const paginationNumbers = document.getElementById('paginationNumbers');

        btnAnterior.disabled = this.paginacion.paginaActual === 1;
        btnSiguiente.disabled = this.paginacion.paginaActual === this.paginacion.totalPaginas;

        // Generar números de página
        let paginasHTML = '';
        const paginasVisibles = 5;
        let inicioPagina = Math.max(1, this.paginacion.paginaActual - Math.floor(paginasVisibles / 2));
        let finPagina = Math.min(this.paginacion.totalPaginas, inicioPagina + paginasVisibles - 1);

        for (let i = inicioPagina; i <= finPagina; i++) {
            paginasHTML += `
                <button class="page-number ${i === this.paginacion.paginaActual ? 'active' : ''}" 
                        onclick="companiesApp.irAPagina(${i})">
                    ${i}
                </button>
            `;
        }

        paginationNumbers.innerHTML = paginasHTML;
    },

    actualizarInfoPaginacion: function(inicio, fin) {
        document.getElementById('mostrandoDesde').textContent = inicio + 1;
        document.getElementById('mostrandoHasta').textContent = Math.min(fin, this.paginacion.totalElementos);
        document.getElementById('totalRegistros').textContent = this.paginacion.totalElementos;
    },

    paginaAnterior: function() {
        if (this.paginacion.paginaActual > 1) {
            this.paginacion.paginaActual--;
            this.mostrarEmpresas();
        }
    },

    paginaSiguiente: function() {
        if (this.paginacion.paginaActual < this.paginacion.totalPaginas) {
            this.paginacion.paginaActual++;
            this.mostrarEmpresas();
        }
    },

    irAPagina: function(pagina) {
        this.paginacion.paginaActual = pagina;
        this.mostrarEmpresas();
    },

    // ==================== CRUD OPERATIONS ====================

    mostrarModalNuevaEmpresa: function() {
        this.empresaEditando = null;
        document.getElementById('formNuevaEmpresa').reset();
        document.getElementById('modalEmpresaTitulo').innerHTML = '<i class="fas fa-plus-circle"></i> Nueva Empresa';
        document.getElementById('modalNuevaEmpresa').style.display = 'block';
    },

    crearEmpresa: async function() {
        const form = document.getElementById('formNuevaEmpresa');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const empresaData = {
            nombre: document.getElementById('nombreEmpresa').value,
            telefono: document.getElementById('telefonoEmpresa').value,
            email: document.getElementById('emailEmpresa').value,
            direccion: document.getElementById('direccionEmpresa').value,
            id_estado_empresa: parseInt(document.getElementById('estadoEmpresa').value)
        };

        try {
            const response = await fetch('/api/empresas', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(empresaData)
            });

            const result = await response.json();
            
            if (!response.ok) {
                throw new Error(result.error || 'Error al crear empresa');
            }

            this.mostrarExito(result.message);
            this.cerrarModal();
            // Recargar los datos después de crear
            await this.cargarEmpresas();

        } catch (error) {
            console.error('Error:', error);
            this.mostrarError(error.message);
        }
    },

    editarEmpresa: async function(idEmpresa) {
        try {
            const response = await fetch(`/api/empresas/${idEmpresa}`);
            if (!response.ok) throw new Error('Error al cargar empresa');

            const empresa = await response.json();
            this.empresaEditando = empresa;

            // Llenar el formulario
            document.getElementById('nombreEmpresa').value = empresa.nombre;
            document.getElementById('telefonoEmpresa').value = empresa.telefono || '';
            document.getElementById('emailEmpresa').value = empresa.email || '';
            document.getElementById('direccionEmpresa').value = empresa.direccion || '';
            document.getElementById('estadoEmpresa').value = empresa.id_estado_empresa;

            // Cambiar título del modal
            document.getElementById('modalEmpresaTitulo').innerHTML = '<i class="fas fa-edit"></i> Editar Empresa';

            document.getElementById('modalNuevaEmpresa').style.display = 'block';

        } catch (error) {
            console.error('Error:', error);
            this.mostrarError('No se pudo cargar la empresa para editar');
        }
    },

    actualizarEmpresa: async function() {
        if (!this.empresaEditando) return;

        const empresaData = {
            nombre: document.getElementById('nombreEmpresa').value,
            telefono: document.getElementById('telefonoEmpresa').value,
            email: document.getElementById('emailEmpresa').value,
            direccion: document.getElementById('direccionEmpresa').value,
            id_estado_empresa: parseInt(document.getElementById('estadoEmpresa').value)
        };

        try {
            const response = await fetch(`/api/empresas/${this.empresaEditando.id_empresa}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(empresaData)
            });

            const result = await response.json();
            
            if (!response.ok) {
                throw new Error(result.error || 'Error al actualizar empresa');
            }

            this.mostrarExito(result.message);
            this.cerrarModal();
            // Recargar los datos después de actualizar
            await this.cargarEmpresas();

        } catch (error) {
            console.error('Error:', error);
            this.mostrarError(error.message);
        }
    },

    eliminarEmpresa: async function(idEmpresa) {
        const confirmacion = await Swal.fire({
            title: '¿Estás seguro?',
            text: "Esta acción no se puede deshacer",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Sí, eliminar',
            cancelButtonText: 'Cancelar'
        });

        if (confirmacion.isConfirmed) {
            try {
                const response = await fetch(`/api/empresas/${idEmpresa}`, {
                    method: 'DELETE'
                });

                const result = await response.json();
                
                if (!response.ok) {
                    throw new Error(result.error || 'Error al eliminar empresa');
                }

                this.mostrarExito(result.message);
                // Recargar los datos después de eliminar
                await this.cargarEmpresas();

            } catch (error) {
                console.error('Error:', error);
                this.mostrarError(error.message);
            }
        }
    },

    verDetalles: async function(idEmpresa) {
        try {
            const response = await fetch(`/api/empresas/${idEmpresa}`);
            if (!response.ok) throw new Error('Error al cargar detalles');

            const empresa = await response.json();
            this.mostrarDetallesEmpresa(empresa);

        } catch (error) {
            console.error('Error:', error);
            this.mostrarError('No se pudieron cargar los detalles de la empresa');
        }
    },

    mostrarDetallesEmpresa: async function(empresa) {
        try {
            // Cargar pedidos de la empresa
            const responsePedidos = await fetch(`/api/empresas/${empresa.id_empresa}/pedidos`);
            const pedidos = responsePedidos.ok ? await responsePedidos.json() : [];

            let pedidosHTML = '';
            if (pedidos.length > 0) {
                pedidosHTML = `
                    <div class="info-group">
                        <h5>Pedidos Recientes</h5>
                        ${pedidos.slice(0, 5).map(pedido => `
                            <div class="border-bottom pb-2 mb-2">
                                <strong>Pedido #${pedido.id_pedido}</strong><br>
                                <small>Cliente: ${this.escapeHtml(pedido.nombre_cliente)}</small><br>
                                <small>Fecha: ${new Date(pedido.fecha_pedido).toLocaleDateString()}</small><br>
                                <small>Total: $${pedido.total_pedido}</small><br>
                                <small>Estado: ${pedido.nombre_estado}</small>
                            </div>
                        `).join('')}
                        ${pedidos.length > 5 ? `<small class="text-muted">... y ${pedidos.length - 5} pedidos más</small>` : ''}
                    </div>
                `;
            }

            const contenido = `
                <div class="detalles-empresa">
                    <div class="info-group">
                        <h5>Información General</h5>
                        <p><strong>Nombre:</strong> ${this.escapeHtml(empresa.nombre)}</p>
                        <p><strong>Email:</strong> ${empresa.email || 'No especificado'}</p>
                        <p><strong>Teléfono:</strong> ${empresa.telefono || 'No especificado'}</p>
                        <p><strong>Estado:</strong> 
                            <span class="estado-badge estado-${empresa.nombre_estado.toLowerCase()}">
                                ${empresa.nombre_estado}
                            </span>
                        </p>
                    </div>

                    <div class="info-group">
                        <h5>Dirección</h5>
                        <div class="direccion-completa">
                            ${empresa.direccion || 'No especificada'}
                        </div>
                    </div>

                    <div class="info-group">
                        <h5>Información del Sistema</h5>
                        <p><strong>Fecha de Registro:</strong> ${new Date(empresa.fecha_creacion).toLocaleDateString()}</p>
                        <p><strong>Última Actualización:</strong> ${new Date(empresa.fecha_actualizacion).toLocaleDateString()}</p>
                    </div>

                    ${pedidosHTML}
                </div>
            `;

            document.getElementById('detallesEmpresaContent').innerHTML = contenido;
            document.getElementById('modalDetallesEmpresa').style.display = 'block';
        } catch (error) {
            console.error('Error cargando pedidos:', error);
        }
    },

    // ==================== UTILITY FUNCTIONS ====================

    cerrarModal: function() {
        document.getElementById('modalNuevaEmpresa').style.display = 'none';
        this.empresaEditando = null;
        // Restaurar título del modal
        document.getElementById('modalEmpresaTitulo').innerHTML = '<i class="fas fa-plus-circle"></i> Nueva Empresa';
    },

    cerrarModalDetalles: function() {
        document.getElementById('modalDetallesEmpresa').style.display = 'none';
    },

    mostrarLoading: function(mostrar) {
        const tbody = document.getElementById('tablaEmpresas');
        if (mostrar) {
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
    },

    mostrarExito: function(mensaje) {
        Swal.fire({
            icon: 'success',
            title: 'Éxito',
            text: mensaje,
            timer: 3000,
            showConfirmButton: false
        });
    },

    mostrarError: function(mensaje) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: mensaje,
            confirmButtonText: 'Aceptar'
        });
    },

    guardarEmpresa: function() {
        if (this.empresaEditando) {
            this.actualizarEmpresa();
        } else {
            this.crearEmpresa();
        }
    },

    escapeHtml: function(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }


};

// Inicializar la aplicación cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    companiesApp.init();
});

// Cerrar modales al hacer clic fuera
window.onclick = function(event) {
    const modalNueva = document.getElementById('modalNuevaEmpresa');
    const modalDetalles = document.getElementById('modalDetallesEmpresa');
    
    if (event.target === modalNueva) {
        companiesApp.cerrarModal();
    }
    if (event.target === modalDetalles) {
        companiesApp.cerrarModalDetalles();
    }
};