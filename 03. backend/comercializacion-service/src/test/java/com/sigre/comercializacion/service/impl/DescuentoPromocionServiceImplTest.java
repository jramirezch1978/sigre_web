package com.sigre.comercializacion.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.DescuentoPromocionRequest;
import com.sigre.comercializacion.entity.DescuentoPromocion;
import com.sigre.comercializacion.repository.DescuentoPromocionRepository;
import com.sigre.comercializacion.testdata.VentasFase4TestDataFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("DescuentoPromocionServiceImpl")
class DescuentoPromocionServiceImplTest {

    @Mock
    private DescuentoPromocionRepository repository;

    @InjectMocks
    private DescuentoPromocionServiceImpl service;

    private DescuentoPromocion descuentoStub(Long id, String flagEstado) {
        DescuentoPromocion d = new DescuentoPromocion();
        d.setId(id);
        d.setNombre("Descuento Test");
        d.setTipo("PORCENTAJE");
        d.setValor(new BigDecimal("10.0000"));
        d.setFechaInicio(LocalDate.now());
        d.setFechaFin(LocalDate.now().plusMonths(1));
        d.setFlagEstado(flagEstado);
        return d;
    }

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // --- findAll ---

    @Test
    @DisplayName("findAll: con filtros retorna página")
    void findAll_conFiltros_retornaPagina() {
        var d = descuentoStub(1L, "1");
        var page = new PageImpl<>(List.of(d));
        var pageable = PageRequest.of(0, 10);

        when(repository.findWithFilters("promo", "PORCENTAJE", "1", pageable)).thenReturn(page);

        Page<DescuentoPromocion> result = service.findAll("promo", "PORCENTAJE", "1", pageable);

        assertThat(result).hasSize(1);
        assertThat(result.getContent().get(0).getNombre()).isEqualTo("Descuento Test");
        verify(repository).findWithFilters("promo", "PORCENTAJE", "1", pageable);
    }

    // --- findById ---

    @Test
    @DisplayName("findById: cuando existe retorna entidad")
    void findById_cuandoExiste_retornaEntidad() {
        var d = descuentoStub(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(d));

        DescuentoPromocion result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("Descuento Test");
    }

    @Test
    @DisplayName("findById: cuando no existe lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("DescuentoPromocion");
    }

    // --- create ---

    @Test
    @DisplayName("create: con datos válidos retorna creado con flagEstado=1 y createdBy seteado")
    void create_conDatosValidos_retornaCreado() {
        var req = VentasFase4TestDataFactory.descuentoRequest("Promo OK", "PORCENTAJE");
        when(repository.save(any())).thenAnswer(inv -> {
            DescuentoPromocion d = inv.getArgument(0);
            d.setId(30L);
            return d;
        });

        DescuentoPromocion result = service.create(req);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("Promo OK");
        assertThat(result.getTipo()).isEqualTo("PORCENTAJE");
    }

    @Test
    @DisplayName("create: cuando tipo es null lanza BusinessException")
    void create_cuandoTipoNull_lanzaBusinessException() {
        var req = VentasFase4TestDataFactory.descuentoRequest("Promo X", null);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo es obligatorio");
    }

    @Test
    @DisplayName("create: cuando tipo es blank lanza BusinessException")
    void create_cuandoTipoBlank_lanzaBusinessException() {
        var req = VentasFase4TestDataFactory.descuentoRequest("Promo X", "   ");

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo es obligatorio");
    }

    // --- update ---

    @Test
    @DisplayName("update: con datos válidos retorna actualizado con updatedBy seteado")
    void update_conDatosValidos_retornaActualizado() {
        var existing = descuentoStub(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var req = DescuentoPromocionRequest.builder()
                .nombre("Actualizado")
                .tipo("MONTO_FIJO")
                .valor(new BigDecimal("25.0000"))
                .fechaInicio(LocalDate.now())
                .fechaFin(LocalDate.now().plusMonths(2))
                .diasAplicacion("LUN,MAR")
                .horaInicio(LocalTime.of(8, 0))
                .horaFin(LocalTime.of(18, 0))
                .montoMinimo(new BigDecimal("50.0000"))
                .build();

        DescuentoPromocion result = service.update(1L, req);

        assertThat(result.getNombre()).isEqualTo("Actualizado");
        assertThat(result.getTipo()).isEqualTo("MONTO_FIJO");
        assertThat(result.getValor()).isEqualByComparingTo(new BigDecimal("25.0000"));
        assertThat(result.getDiasAplicacion()).isEqualTo("LUN,MAR");
        assertThat(result.getHoraInicio()).isEqualTo(LocalTime.of(8, 0));
        assertThat(result.getHoraFin()).isEqualTo(LocalTime.of(18, 0));
        assertThat(result.getMontoMinimo()).isEqualByComparingTo(new BigDecimal("50.0000"));
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("update: cuando id no existe lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        var req = VentasFase4TestDataFactory.descuentoRequest("Cualquier", "PORCENTAJE");

        assertThatThrownBy(() -> service.update(99L, req))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("DescuentoPromocion");
    }

    @Test
    @DisplayName("update: cuando tipo es null lanza BusinessException")
    void update_cuandoTipoNull_lanzaBusinessException() {
        var req = VentasFase4TestDataFactory.descuentoRequest("Promo X", null);

        assertThatThrownBy(() -> service.update(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo es obligatorio");
    }

    @Test
    @DisplayName("update: cuando tipo es blank lanza BusinessException")
    void update_cuandoTipoBlank_lanzaBusinessException() {
        var req = VentasFase4TestDataFactory.descuentoRequest("Promo X", "   ");

        assertThatThrownBy(() -> service.update(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("tipo es obligatorio");
    }

    // --- delete ---

    @Test
    @DisplayName("delete: cuando existe cambia flagEstado a 0 y setea updatedBy")
    void delete_cuandoExiste_cambiaFlagEstado() {
        var d = descuentoStub(7L, "1");
        when(repository.findById(7L)).thenReturn(Optional.of(d));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.delete(7L);

        assertThat(d.getFlagEstado()).isEqualTo("0");
        assertThat(d.getUpdatedBy()).isEqualTo(1L);
        verify(repository).save(d);
    }

    @Test
    @DisplayName("delete: cuando no existe lanza ResourceNotFoundException")
    void delete_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.delete(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("DescuentoPromocion");
    }

    // --- activar ---

    @Test
    @DisplayName("activar: cuando existe cambia flagEstado a 1 y setea updatedBy")
    void activar_cuandoExiste_cambiaFlagEstado() {
        var d = descuentoStub(8L, "0");
        when(repository.findById(8L)).thenReturn(Optional.of(d));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        DescuentoPromocion result = service.activar(8L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("activar: cuando no existe lanza ResourceNotFoundException")
    void activar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("DescuentoPromocion");
    }

    // --- desactivar ---

    @Test
    @DisplayName("desactivar: cuando existe cambia flagEstado a 0 y setea updatedBy")
    void desactivar_cuandoExiste_cambiaFlagEstado() {
        var d = descuentoStub(9L, "1");
        when(repository.findById(9L)).thenReturn(Optional.of(d));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        DescuentoPromocion result = service.desactivar(9L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("desactivar: cuando no existe lanza ResourceNotFoundException")
    void desactivar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("DescuentoPromocion");
    }
}
