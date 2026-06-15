package com.sigre.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import com.sigre.finanzas.dto.request.LiquidacionDetalleRequest;
import com.sigre.finanzas.dto.response.LiquidacionDetResponse;
import com.sigre.finanzas.entity.Liquidacion;
import com.sigre.finanzas.entity.LiquidacionDet;

import java.math.BigDecimal;
import java.time.Instant;


@DisplayName("Pruebas Unitarias - LiquidacionDetMapper")
class LiquidacionDetMapperTest {

    private LiquidacionDetMapper mapper;

    @BeforeEach
    void setUp() {
        mapper = new LiquidacionDetMapper();
    }


    // ==== toEntity — otros ====

    @Test
    @DisplayName("toEntity debe mapear todos los campos del request a la entidad")
    void toEntity_debeMapearTodosLosCampos() {
        LiquidacionDetalleRequest request = new LiquidacionDetalleRequest();
        request.setItem(1);
        request.setOrigenDocRef("F001-00000001");
        request.setMonedaId(1L);
        request.setConceptoFinancieroId(2L);
        request.setCntasPagarId(1001L);
        request.setCntasCobrarId(null);
        request.setCentrosCostoId(1L);
        request.setFactorSigno(Short.valueOf("1"));
        request.setImporte(new BigDecimal("1500.00"));
        request.setFlagRetencion("0");
        request.setImporteRetenido(BigDecimal.ZERO);
        request.setFlagProvisionado("0");

        LiquidacionDet entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getItem()).isEqualTo(1);
        assertThat(entity.getOrigenDocRef()).isEqualTo("F001-00000001");
        assertThat(entity.getMonedaId()).isEqualTo(1L);
        assertThat(entity.getConceptoFinancieroId()).isEqualTo(2L);
        assertThat(entity.getCntasPagarId()).isEqualTo(1001L);
        assertThat(entity.getCntasCobrarId()).isNull();
        assertThat(entity.getCentrosCostoId()).isEqualTo(1L);
        assertThat(entity.getFactorSigno()).isEqualTo(Short.valueOf("1"));
        assertThat(entity.getImporte()).isEqualTo(new BigDecimal("1500.00"));
        assertThat(entity.getFlagRetencion()).isEqualTo("0");
        assertThat(entity.getImporteRetenido()).isEqualTo(BigDecimal.ZERO);
        assertThat(entity.getFlagProvisionado()).isEqualTo("0");
    }


    // ==== toResponse — otros ====

    @Test
    @DisplayName("toResponse debe mapear todos los campos de la entidad al response")
    void toResponse_debeMapearTodosLosCampos() {
        Liquidacion liquidacion = new Liquidacion();
        liquidacion.setId(10L);

        LiquidacionDet entity = new LiquidacionDet();
        entity.setId(5L);
        entity.setLiquidacion(liquidacion);
        entity.setItem(2);
        entity.setOrigenDocRef("B001-00000002");
        entity.setMonedaId(1L);
        entity.setConceptoFinancieroId(3L);
        entity.setCntasPagarId(1002L);
        entity.setCntasCobrarId(2001L);
        entity.setCentrosCostoId(2L);
        entity.setFactorSigno(Short.valueOf("-1"));
        entity.setImporte(new BigDecimal("2500.00"));
        entity.setFlagRetencion("1");
        entity.setImporteRetenido(new BigDecimal("250.00"));
        entity.setFlagProvisionado("1");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-05-01T10:00:00Z"));
        entity.setUpdatedBy(2L);
        entity.setFecModificacion(Instant.parse("2026-05-15T14:30:00Z"));

        LiquidacionDetResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(5L);
        assertThat(response.getLiquidacionId()).isEqualTo(10L);
        assertThat(response.getItem()).isEqualTo(2);
        assertThat(response.getOrigenDocRef()).isEqualTo("B001-00000002");
        assertThat(response.getMonedaId()).isEqualTo(1L);
        assertThat(response.getConceptoFinancieroId()).isEqualTo(3L);
        assertThat(response.getCntasPagarId()).isEqualTo(1002L);
        assertThat(response.getCntasCobrarId()).isEqualTo(2001L);
        assertThat(response.getCentrosCostoId()).isEqualTo(2L);
        assertThat(response.getFactorSigno()).isEqualTo(Short.valueOf("-1"));
        assertThat(response.getImporte()).isEqualTo(new BigDecimal("2500.00"));
        assertThat(response.getFlagRetencion()).isEqualTo("1");
        assertThat(response.getImporteRetenido()).isEqualTo(new BigDecimal("250.00"));
        assertThat(response.getFlagProvisionado()).isEqualTo("1");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getUpdatedBy()).isEqualTo(2L);
        assertThat(response.getFecModificacion()).isNotNull();
    }


    // ==== toResponse — edge cases ====

    @Test
    @DisplayName("toResponse con liquidacion null debe retornar liquidacionId null")
    void toResponse_conLiquidacionNull_debeRetornarLiquidacionIdNull() {
        LiquidacionDet entity = new LiquidacionDet();
        entity.setId(1L);

        LiquidacionDetResponse response = mapper.toResponse(entity);

        assertThat(response.getLiquidacionId()).isNull();
    }
}
