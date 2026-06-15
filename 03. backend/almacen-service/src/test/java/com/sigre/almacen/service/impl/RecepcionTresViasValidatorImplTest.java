package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.domain.MovimientoErrorCode;
import com.sigre.almacen.entity.InventarioConteo;
import com.sigre.almacen.repository.InventarioConteoRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThatCode;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RecepcionTresViasValidatorImplTest {

    @Mock
    private JdbcTemplate jdbcTemplate;
    @Mock
    private InventarioConteoRepository inventarioConteoRepository;
    @InjectMocks
    private RecepcionTresViasValidatorImpl validator;

    @Test
    void validar_ocFacturaYConteoCoinciden_ok() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "10");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        InventarioConteo conteo = new InventarioConteo();
        conteo.setId(5L);
        conteo.setAlmacenId(20L);
        conteo.setArticuloId(100L);
        conteo.setCantidadConteo1(new BigDecimal("10"));
        when(inventarioConteoRepository.findById(5L)).thenReturn(Optional.of(conteo));

        assertThatCode(() -> validator.validarRecepcionOc(1L, 20L, 5L, new BigDecimal("0.0001")))
                .doesNotThrowAnyException();
    }

    @Test
    void validar_rechazaSinFactura() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "0");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        assertThatThrownBy(() -> validator.validarRecepcionOc(1L, 20L, null, null))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.VALIDACION_TRES_VIAS)
                .hasFieldOrPropertyWithValue("status", HttpStatus.UNPROCESSABLE_ENTITY);
    }

    @Test
    void validar_rechazaRecepcionMayorQueFacturadoPendiente() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "5");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        assertThatThrownBy(() -> validator.validarRecepcionOc(1L, 20L, null, null))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.VALIDACION_TRES_VIAS);
    }

    @Test
    void validar_rechazaDiferenciaOcVsFactura() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "8");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        assertThatThrownBy(() -> validator.validarRecepcionOc(1L, 20L, null, null))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.VALIDACION_TRES_VIAS);
    }

    @Test
    void validar_rechazaConteoDistintoConTolerancia() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "10");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        InventarioConteo conteo = new InventarioConteo();
        conteo.setId(5L);
        conteo.setAlmacenId(20L);
        conteo.setArticuloId(100L);
        conteo.setCantidadConteo1(new BigDecimal("9"));
        when(inventarioConteoRepository.findById(5L)).thenReturn(Optional.of(conteo));

        assertThatThrownBy(() -> validator.validarRecepcionOc(1L, 20L, 5L, new BigDecimal("0.0001")))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.VALIDACION_TRES_VIAS);
    }

    @Test
    void validar_sinLineasPendientes_noLanza() {
        Map<String, Object> row = lineaOc(100L, "10", "10", "10");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        assertThatCode(() -> validator.validarRecepcionOc(1L, 20L, null, null))
                .doesNotThrowAnyException();
    }

    @Test
    void validar_ignoraLineaDeOtroAlmacen() {
        Map<String, Object> otra = lineaOc(100L, "10", "0", "10");
        otra.put("almacen_id", 99L);
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(otra));

        assertThatCode(() -> validator.validarRecepcionOc(1L, 20L, null, null))
                .doesNotThrowAnyException();
    }

    @Test
    void validar_conteoDeOtroAlmacen_falla() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "10");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));

        InventarioConteo conteo = new InventarioConteo();
        conteo.setId(5L);
        conteo.setAlmacenId(99L);
        conteo.setArticuloId(100L);
        conteo.setCantidadConteo1(new BigDecimal("10"));
        when(inventarioConteoRepository.findById(5L)).thenReturn(Optional.of(conteo));

        assertThatThrownBy(() -> validator.validarRecepcionOc(1L, 20L, 5L, null))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.VALIDACION_TRES_VIAS);
    }

    @Test
    void validar_conteoInexistente_lanzaError() {
        Map<String, Object> row = lineaOc(100L, "10", "0", "10");
        when(jdbcTemplate.queryForList(any(String.class), eq(1L))).thenReturn(List.of(row));
        when(inventarioConteoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> validator.validarRecepcionOc(1L, 20L, 99L, null))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    private static Map<String, Object> lineaOc(long articuloId, String proj, String proc, String fact) {
        Map<String, Object> row = new HashMap<>();
        row.put("id", 1L);
        row.put("articulo_id", articuloId);
        row.put("cant_proyectada", new BigDecimal(proj));
        row.put("cant_procesada", new BigDecimal(proc));
        row.put("cant_facturada", new BigDecimal(fact));
        row.put("almacen_id", 20L);
        return row;
    }
}
