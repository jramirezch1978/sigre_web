package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.entity.PuntoVenta;
import com.sigre.comercializacion.mapper.PuntoVentaMapper;
import com.sigre.comercializacion.repository.PuntoVentaRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PuntoVentaServiceImpl — Pruebas Unitarias")
class PuntoVentaServiceImplTest {

    private static final Pageable PAGE = PageRequest.of(0, 20);

    @Mock
    private PuntoVentaRepository repository;
    @Mock
    private PuntoVentaMapper mapper;
    @InjectMocks
    private PuntoVentaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findById ====

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExiste_retornaEntidad() {
        when(repository.findByIdWithRelations(1L)).thenReturn(Optional.of(entity(1L, "PV01", "1")));

        var result = service.findById(1L);

        assertThat(result.getCodigo()).isEqualTo("PV01");
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== findAll ====

    @Test
    @DisplayName("findAll() sin filtros -> retorna pagina")
    void findAll_sinFiltros_retornaPagina() {
        when(repository.findAll(PAGE)).thenReturn(new PageImpl<>(List.of()));

        var result = service.findAll(PAGE);

        assertThat(result.getContent()).isEmpty();
        verify(repository).findAll(PAGE);
    }

    @Test
    @DisplayName("findAllWithFilters() con filtros -> retorna pagina filtrada")
    void findAllWithFilters_conFiltros_retornaPagina() {
        when(repository.findAllWithFilters(eq(1L), eq("PV"), eq("Caja"), eq("1"), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        var result = service.findAllWithFilters(1L, "PV", "Caja", "1", PAGE);

        assertThat(result.getContent()).isEmpty();
        verify(repository). findAllWithFilters(1L, "PV", "Caja", "1", PAGE);
    }

    // ==== findBySucursalId ====

    @Test
    @DisplayName("findBySucursalId() -> retorna lista de activos")
    void findBySucursalId_retornaActivos() {
        when(repository.findBySucursalIdAndActivo(1L)).thenReturn(List.of(entity(1L, "PV01", "1")));

        var result = service.findBySucursalId(1L);

        assertThat(result).hasSize(1);
        assertThat(result.getFirst().getCodigo()).isEqualTo("PV01");
        verify(repository).findBySucursalIdAndActivo(1L);
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> normaliza código y persiste")
    void create_conDatosValidos_normalizaYPersiste() {
        PuntoVenta input = entity(null, "pv-new", null);
        when(repository.existsBySucursalIdAndCodigoAndFlagEstado(1L, "PV-NEW", "1")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> {
            PuntoVenta e = inv.getArgument(0);
            e.setId(10L);
            return e;
        });
        when(repository.findByIdWithRelations(10L)).thenAnswer(inv -> Optional.of(input));

        PuntoVenta out = service.create(input);

        assertThat(out.getCodigo()).isEqualTo("PV-NEW");
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("create() con código duplicado -> lanza BusinessException")
    void create_cuandoCodigoDuplicado_lanzaBusinessException() {
        PuntoVenta input = entity(null, "PV-DUP", null);
        when(repository.existsBySucursalIdAndCodigoAndFlagEstado(1L, "PV-DUP", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("código");
    }

    @Test
    @DisplayName("create() con serie boleta duplicada -> lanza BusinessException")
    void create_cuandoSerieBoletaDuplicada_lanzaBusinessException() {
        PuntoVenta input = entity(null, "PV01", null);
        input.setSerieBoleta("B001");
        when(repository.existsBySucursalIdAndCodigoAndFlagEstado(1L, "PV01", "1")).thenReturn(false);
        when(repository.existsBySucursalIdAndSerieBoletaAndFlagEstado(1L, "B001", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("serie de boleta");
    }

    @Test
    @DisplayName("create() con serie factura duplicada -> lanza BusinessException")
    void create_cuandoSerieFacturaDuplicada_lanzaBusinessException() {
        PuntoVenta input = entity(null, "PV01", null);
        input.setSerieFactura("F001");
        when(repository.existsBySucursalIdAndCodigoAndFlagEstado(1L, "PV01", "1")).thenReturn(false);
        when(repository.existsBySucursalIdAndSerieFacturaAndFlagEstado(1L, "F001", "1")).thenReturn(true);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("serie de factura");
    }

    @Test
    @DisplayName("create() con almacén inexistente -> lanza BusinessException")
    void create_cuandoAlmacenInvalido_lanzaBusinessException() {
        PuntoVenta input = entity(null, "PV02", null);
        input.setAlmacenId(99L);
        when(repository.existsBySucursalIdAndCodigoAndFlagEstado(1L, "PV02", "1")).thenReturn(false);
        when(repository.existsAlmacenActivo(99L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("almacén");
    }

    @Test
    @DisplayName("create() con almacén de otra sucursal -> lanza BusinessException")
    void create_cuandoAlmacenSucursalInvalida_lanzaBusinessException() {
        PuntoVenta input = entity(null, "PV03", null);
        input.setAlmacenId(50L);
        when(repository.existsBySucursalIdAndCodigoAndFlagEstado(1L, "PV03", "1")).thenReturn(false);
        when(repository.existsAlmacenActivo(50L)).thenReturn(true);
        when(repository.existsAlmacenByIdAndSucursalId(50L, 1L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(input))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("almacén indicado no pertenece");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        PuntoVenta existing = entity(5L, "OLD", "1");
        PuntoVenta patch = entity(null, "new", null);
        when(repository.findByIdWithRelations(5L)).thenReturn(Optional.of(existing));
        when(repository.existsBySucursalIdAndCodigoAndFlagEstadoAndIdNot(1L, "NEW", "1", 5L)).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.update(5L, patch);

        assertThat(result.getCodigo()).isEqualTo("NEW");
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(5L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(5L, entity(null, "X", null)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("5");
    }

    @Test
    @DisplayName("update() con código duplicado -> lanza BusinessException")
    void update_cuandoCodigoDuplicado_lanzaBusinessException() {
        PuntoVenta existing = entity(5L, "OLD", "1");
        PuntoVenta patch = entity(null, "DUP", null);
        when(repository.findByIdWithRelations(5L)).thenReturn(Optional.of(existing));
        when(repository.existsBySucursalIdAndCodigoAndFlagEstadoAndIdNot(1L, "DUP", "1", 5L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(5L, patch))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("código");
    }

    @Test
    @DisplayName("update() con serie boleta duplicada -> lanza BusinessException")
    void update_cuandoSerieBoletaDuplicada_lanzaBusinessException() {
        PuntoVenta existing = entity(5L, "OLD", "1");
        PuntoVenta patch = entity(null, "NEW", null);
        patch.setSerieBoleta("B001");
        when(repository.findByIdWithRelations(5L)).thenReturn(Optional.of(existing));
        when(repository.existsBySucursalIdAndCodigoAndFlagEstadoAndIdNot(1L, "NEW", "1", 5L)).thenReturn(false);
        when(repository.existsBySucursalIdAndSerieBoletaAndFlagEstadoAndIdNot(1L, "B001", "1", 5L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(5L, patch))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("serie de boleta");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1")
    void activate_cuandoExiste_cambiaFlagEstado() {
        PuntoVenta pv = entity(3L, "PV03", "0");
        when(repository.findByIdWithRelations(3L)).thenReturn(Optional.of(pv));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.activate(3L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("activate() con ID inexistente -> lanza ResourceNotFoundException")
    void activate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        PuntoVenta pv = entity(4L, "PV04", "1");
        when(repository.findByIdWithRelations(4L)).thenReturn(Optional.of(pv));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.deactivate(4L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("deactivate() con ID inexistente -> lanza ResourceNotFoundException")
    void deactivate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithRelations(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.deactivate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> elimina via repository")
    void delete_cuandoExiste_elimina() {
        PuntoVenta pv = entity(6L, "PV06", "1");
        when(repository.findById(6L)).thenReturn(Optional.of(pv));

        service.delete(6L);

        verify(repository).delete(pv);
    }

    @Test
    @DisplayName("delete() con ID inexistente -> lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== helpers ====

    private static PuntoVenta entity(Long id, String codigo, String flag) {
        PuntoVenta pv = new PuntoVenta();
        pv.setId(id);
        pv.setSucursalId(1L);
        pv.setCodigo(codigo);
        pv.setNombre("PV " + codigo);
        if (flag != null) {
            pv.setFlagEstado(flag);
        }
        return pv;
    }
}
