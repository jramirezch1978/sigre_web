package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.PedidoMesaRequest;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.entity.PedidoMesa;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.repository.PedidoMesaRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PedidoMesaServiceImpl — Pruebas Unitarias")
class PedidoMesaServiceImplTest {

    @Mock
    private PedidoMesaRepository pedidoMesaRepository;
    @Mock
    private MesaRepository mesaRepository;
    @Mock
    private VentasFkValidator fkValidator;
    @InjectMocks
    private PedidoMesaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(10L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findAll ====

    @Test
    @DisplayName("findAll() -> delega en repositorio con Specification")
    void findAll_delegaEnRepositorioConSpecification() {
        when(pedidoMesaRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));

        var result = service.findAll(1L, null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).isEmpty();
        verify(pedidoMesaRepository).findAll(any(Specification.class), eq(Pageable.unpaged()));
    }

    // ==== getById ====

    @Test
    @DisplayName("getById() con ID existente -> retorna pedido")
    void getById_cuandoExiste_retornaPedido() {
        PedidoMesa p = pedido(1L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(1L)).thenReturn(Optional.of(p));

        var result = service.getById(1L);

        assertThat(result.getNumero()).isEqualTo("PED-001");
    }

    @Test
    @DisplayName("getById() con ID inexistente -> lanza ResourceNotFoundException")
    void getById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(pedidoMesaRepository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.getById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste y retorna pedido")
    void create_conDatosValidos_retornaCreado() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstado("PED-001", "1")).thenReturn(false);
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> {
            PedidoMesa p = inv.getArgument(0);
            p.setId(5L);
            return p;
        });

        var resp = service.create(pedidoRequest());

        assertThat(resp.getId()).isEqualTo(5L);
        assertThat(resp.getTipo()).isEqualTo("MESA");
    }

    @Test
    @DisplayName("create() con número duplicado -> lanza BusinessException")
    void create_cuandoNumeroDuplicado_lanzaBusinessException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstado("PED-001", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(pedidoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Número de pedido duplicado");
    }

    @Test
    @DisplayName("create() con sucursal inactiva -> lanza BusinessException")
    void create_cuandoSucursalInactiva_lanzaBusinessException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(pedidoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Sucursal no válida");
    }

    @Test
    @DisplayName("create() sin usuario en contexto -> lanza BusinessException")
    void create_sinUsuario_lanzaBusinessException() {
        TenantContext.clear();

        assertThatThrownBy(() -> service.create(pedidoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Usuario no resoluble");
    }

    @Test
    @DisplayName("create() con mesa -> asigna mesa y valida disponibilidad")
    void create_conMesa_asignaYValidaDisponibilidad() {
        Mesa mesa = new Mesa();
        mesa.setId(20L);
        mesa.setNumero("M-20");
        Mesa.Zona zona = new Mesa.Zona();
        Mesa.Zona.Sucursal suc = new Mesa.Zona.Sucursal();
        suc.setId(10L);
        zona.setSucursal(suc);
        mesa.setZona(zona);

        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstado("PED-001", "1")).thenReturn(false);
        when(mesaRepository.findByIdWithRelations(20L)).thenReturn(Optional.of(mesa));
        when(pedidoMesaRepository.existsByMesa_IdAndFlagEstado(20L, "1")).thenReturn(false);
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> {
            PedidoMesa p = inv.getArgument(0);
            p.setId(8L);
            return p;
        });

        PedidoMesaRequest req = pedidoRequest();
        req.setMesaId(20L);

        assertThat(service.create(req).getMesaId()).isEqualTo(20L);
    }

    @Test
    @DisplayName("create() con mesa no existente -> lanza ResourceNotFoundException")
    void create_cuandoMesaNoExiste_lanzaResourceNotFoundException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstado("PED-001", "1")).thenReturn(false);
        when(mesaRepository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        PedidoMesaRequest req = pedidoRequest();
        req.setMesaId(99L);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Mesa");
    }

    @Test
    @DisplayName("create() con mesa ocupada -> lanza BusinessException")
    void create_cuandoMesaOcupada_lanzaBusinessException() {
        Mesa mesa = new Mesa();
        mesa.setId(20L);
        Mesa.Zona zona = new Mesa.Zona();
        Mesa.Zona.Sucursal suc = new Mesa.Zona.Sucursal();
        suc.setId(10L);
        zona.setSucursal(suc);
        mesa.setZona(zona);

        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstado("PED-001", "1")).thenReturn(false);
        when(mesaRepository.findByIdWithRelations(20L)).thenReturn(Optional.of(mesa));
        when(pedidoMesaRepository.existsByMesa_IdAndFlagEstado(20L, "1")).thenReturn(true);

        PedidoMesaRequest req = pedidoRequest();
        req.setMesaId(20L);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("La mesa ya tiene un pedido activo");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        PedidoMesa p = pedido(2L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(2L)).thenReturn(Optional.of(p));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstadoAndIdNot("PED-002", "1", 2L)).thenReturn(false);
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        PedidoMesaRequest req = pedidoRequest();
        req.setNumero("PED-002");

        assertThat(service.update(2L, req).getNumero()).isEqualTo("PED-002");
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(pedidoMesaRepository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(99L, pedidoRequest()))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("update() con número duplicado -> lanza BusinessException")
    void update_cuandoNumeroDuplicado_lanzaBusinessException() {
        PedidoMesa p = pedido(2L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(2L)).thenReturn(Optional.of(p));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstadoAndIdNot("PED-002", "1", 2L)).thenReturn(true);

        PedidoMesaRequest req = pedidoRequest();
        req.setNumero("PED-002");

        assertThatThrownBy(() -> service.update(2L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Número de pedido duplicado");
    }

    // ==== cerrar ====

    @Test
    @DisplayName("cerrar() con pedido activo -> cambia flagEstado a 2")
    void cerrar_conPedidoActivo_cambiaFlagEstado() {
        PedidoMesa p = pedido(3L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(3L)).thenReturn(Optional.of(p));
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.cerrar(3L);

        assertThat(result.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("cerrar() con ID inexistente -> lanza ResourceNotFoundException")
    void cerrar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(pedidoMesaRepository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cerrar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== anular ====

    @Test
    @DisplayName("anular() con pedido activo -> cambia flagEstado a 0")
    void anular_conPedidoActivo_cambiaFlagEstado() {
        PedidoMesa p = pedido(4L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(4L)).thenReturn(Optional.of(p));
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.anular(4L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() con pedido cerrado -> lanza BusinessException")
    void anular_cuandoCerrado_lanzaBusinessException() {
        PedidoMesa p = pedido(5L, "2");
        when(pedidoMesaRepository.findByIdWithRelations(5L)).thenReturn(Optional.of(p));

        assertThatThrownBy(() -> service.anular(5L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrado o anulado");
    }

    @Test
    @DisplayName("anular() con ID inexistente -> lanza ResourceNotFoundException")
    void anular_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(pedidoMesaRepository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1")
    void activate_cuandoExiste_cambiaFlagEstado() {
        PedidoMesa p = pedido(6L, "0");
        when(pedidoMesaRepository.findByIdWithRelations(6L)).thenReturn(Optional.of(p));
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.activate(6L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("activate() con ID inexistente -> lanza ResourceNotFoundException")
    void activate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(pedidoMesaRepository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        PedidoMesa p = pedido(7L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(7L)).thenReturn(Optional.of(p));
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.deactivate(7L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> desactiva via deactivate")
    void delete_cuandoExiste_desactiva() {
        PedidoMesa p = pedido(8L, "1");
        when(pedidoMesaRepository.findByIdWithRelations(8L)).thenReturn(Optional.of(p));
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.delete(8L);

        verify(pedidoMesaRepository).save(any());
    }

    @Test
    @DisplayName("findAll() sin sucursal -> usa contexto")
    void findAll_sinSucursal_usaContexto() {
        when(pedidoMesaRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));
        var result = service.findAll(null, null, null, null, null, Pageable.unpaged());
        assertThat(result.getContent()).isEmpty();
    }

    @Test
    @DisplayName("create() sin sucursal en request -> usa contexto")
    void create_sinSucursalEnRequest_usaContexto() {
        when(pedidoMesaRepository.existsByNumeroAndFlagEstado("PED-001", "1")).thenReturn(false);
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> {
            PedidoMesa p = inv.getArgument(0);
            p.setId(10L);
            return p;
        });
        PedidoMesaRequest req = new PedidoMesaRequest();
        req.setTipo("mesa");
        req.setNumero("PED-001");
        req.setComensales(2);
        var resp = service.create(req);
        assertThat(resp.getId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("update() con sucursal inconsistente en pedido -> lanza BusinessException")
    void update_cuandoSucursalInconsistente_lanzaBusinessException() {
        PedidoMesa p = pedido(9L, "1");
        p.setSucursalId(5L);
        when(pedidoMesaRepository.findByIdWithRelations(9L)).thenReturn(Optional.of(p));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        PedidoMesaRequest req = pedidoRequest();
        assertThatThrownBy(() -> service.update(9L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursalId inconsistente");
    }

    @Test
    @DisplayName("update() con cambio de mesa -> asigna nueva y libera anterior")
    void update_conCambioDeMesa_asignaNuevaYLiberaAnterior() {
        Mesa oldMesa = new Mesa();
        oldMesa.setId(10L);

        Mesa newMesa = new Mesa();
        newMesa.setId(20L);
        newMesa.setNumero("M-20");
        Mesa.Zona zona = new Mesa.Zona();
        Mesa.Zona.Sucursal suc = new Mesa.Zona.Sucursal();
        suc.setId(10L);
        zona.setSucursal(suc);
        newMesa.setZona(zona);

        PedidoMesa p = pedido(3L, "1");
        p.setMesa(oldMesa);

        when(pedidoMesaRepository.findByIdWithRelations(3L)).thenReturn(Optional.of(p));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstadoAndIdNot("PED-001", "1", 3L)).thenReturn(false);
        when(mesaRepository.findByIdWithRelations(10L)).thenReturn(Optional.of(oldMesa));
        when(mesaRepository.findByIdWithRelations(20L)).thenReturn(Optional.of(newMesa));
        when(pedidoMesaRepository.existsByMesa_IdAndFlagEstadoAndIdNot(20L, "1", 3L)).thenReturn(false);
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        PedidoMesaRequest req = pedidoRequest();
        req.setMesaId(20L);

        var result = service.update(3L, req);
        assertThat(result.getMesaId()).isEqualTo(20L);
    }

    @Test
    @DisplayName("update() con desasignacion de mesa -> libera anterior, no asigna nueva")
    void update_conDesasignacionDeMesa_liberaAnterior() {
        Mesa oldMesa = new Mesa();
        oldMesa.setId(10L);

        PedidoMesa p = pedido(4L, "1");
        p.setMesa(oldMesa);

        when(pedidoMesaRepository.findByIdWithRelations(4L)).thenReturn(Optional.of(p));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(pedidoMesaRepository.existsByNumeroAndFlagEstadoAndIdNot("PED-001", "1", 4L)).thenReturn(false);
        when(mesaRepository.findByIdWithRelations(10L)).thenReturn(Optional.of(oldMesa));
        when(pedidoMesaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        PedidoMesaRequest req = pedidoRequest();
        req.setMesaId(null);

        var result = service.update(4L, req);
        assertThat(result.getMesaId()).isNull();
    }

    @Test
    @DisplayName("anular() con pedido ya anulado -> lanza BusinessException")
    void anular_cuandoYaAnulado_lanzaBusinessException() {
        PedidoMesa p = pedido(5L, "0");
        when(pedidoMesaRepository.findByIdWithRelations(5L)).thenReturn(Optional.of(p));
        assertThatThrownBy(() -> service.anular(5L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrado o anulado");
    }

    // ==== helpers ====

    private static PedidoMesaRequest pedidoRequest() {
        PedidoMesaRequest req = new PedidoMesaRequest();
        req.setSucursalId(10L);
        req.setTipo("mesa");
        req.setNumero("PED-001");
        req.setComensales(4);
        return req;
    }

    private static PedidoMesa pedido(Long id, String flag) {
        PedidoMesa p = new PedidoMesa();
        p.setId(id);
        p.setSucursalId(10L);
        p.setTipo("MESA");
        p.setNumero("PED-001");
        p.setFlagEstado(flag);
        return p;
    }
}
