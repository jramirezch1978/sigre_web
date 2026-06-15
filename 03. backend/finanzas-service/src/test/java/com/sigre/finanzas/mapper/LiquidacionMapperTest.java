package com.sigre.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import com.sigre.finanzas.dto.request.LiquidacionRequest;
import com.sigre.finanzas.dto.response.LiquidacionDetalleResponse;
import com.sigre.finanzas.dto.response.LiquidacionResponse;
import com.sigre.finanzas.entity.Liquidacion;
import com.sigre.finanzas.entity.LiquidacionDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@DisplayName("Pruebas Unitarias - LiquidacionMapper")
class LiquidacionMapperTest {

    private LiquidacionMapper mapper;
    private Liquidacion entity;
    private LiquidacionRequest request;

    @BeforeEach
    void setUp() {
        mapper = new LiquidacionMapper(new LiquidacionDetMapper());

        entity = new Liquidacion();
        entity.setId(1L);
        entity.setSolicitudGiroId(10L);
        entity.setNroLiquidacion("LIQ-001");
        entity.setSucursalId(1L);
        entity.setDocTipoId(5L);
        entity.setProveedorId(100L);
        entity.setFechaLiquidacion(LocalDate.of(2026, 5, 1));
        entity.setTipoLiquidacion("P");
        entity.setMonedaId(1L);
        entity.setConceptoFinancieroId(20L);
        entity.setImporteNeto(new BigDecimal("5000.00"));
        entity.setSaldo(new BigDecimal("5000.00"));
        entity.setTasaCambio(BigDecimal.ONE);
        entity.setAnio(2026);
        entity.setMes(5);
        entity.setCntblLibroId(30L);
        entity.setCntblAsientoId(40L);
        entity.setUsuarioId(1L);
        entity.setObservacion("Test liquidacion");
        entity.setFlagEstado("1");
        entity.setFechaRegistro(LocalDate.of(2026, 5, 1));
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        request = new LiquidacionRequest();
        request.setSolicitudGiroId(10L);
        request.setNroLiquidacion("LIQ-001");
        request.setSucursalId(1L);
        request.setDocTipoId(5L);
        request.setProveedorId(100L);
        request.setFechaLiquidacion(LocalDate.of(2026, 5, 1));
        request.setTipoLiquidacion("P");
        request.setMonedaId(1L);
        request.setConceptoFinancieroId(20L);
        request.setImporteNeto(new BigDecimal("5000.00"));
        request.setTasaCambio(BigDecimal.ONE);
        request.setAnio(2026);
        request.setMes(5);
        request.setCntblLibroId(30L);
        request.setUsuarioId(1L);
        request.setObservacion("Test liquidacion");
    }

    // ==== toEntity ====

    @Test
    @DisplayName("toEntity() con request valido -> retorna entity")
    void toEntity_conRequestValido_retornaEntity() {
        Liquidacion result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getSolicitudGiroId()).isEqualTo(10L);
        assertThat(result.getNroLiquidacion()).isEqualTo("LIQ-001");
        assertThat(result.getSucursalId()).isEqualTo(1L);
        assertThat(result.getImporteNeto()).isEqualByComparingTo(new BigDecimal("5000.00"));
        assertThat(result.getSaldo()).isEqualByComparingTo(BigDecimal.ZERO);
    }

    @Test
    @DisplayName("toEntity() con nroLiquidacion null -> no asigna numero")
    void toEntity_conNroLiquidacionNull_noAsignaNumero() {
        request.setNroLiquidacion(null);

        Liquidacion result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getNroLiquidacion()).isNull();
    }

    // ==== toResponse ====

    @Test
    @DisplayName("toResponse() con entity valida -> retorna response")
    void toResponse_conEntityValida_retornaResponse() {
        LiquidacionResponse result = mapper.toResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNroLiquidacion()).isEqualTo("LIQ-001");
        assertThat(result.getImporteNeto()).isEqualByComparingTo(new BigDecimal("5000.00"));
        assertThat(result.getSaldo()).isEqualByComparingTo(new BigDecimal("5000.00"));
    }

    // ==== toDetalleResponse ====

    @Test
    @DisplayName("toDetalleResponse() con detalles no nulos -> mapea detalles activos")
    void toDetalleResponse_conDetallesNoNulos_mapeaDetalles() {
        LiquidacionDet det1 = new LiquidacionDet();
        det1.setId(100L);
        det1.setLiquidacion(entity);
        det1.setItem(1);
        det1.setImporte(new BigDecimal("2000.00"));
        det1.setFlagEstado("1");

        LiquidacionDet det2 = new LiquidacionDet();
        det2.setId(101L);
        det2.setLiquidacion(entity);
        det2.setItem(2);
        det2.setImporte(new BigDecimal("3000.00"));
        det2.setFlagEstado("0");

        entity.setDetalles(List.of(det1, det2));

        LiquidacionDetalleResponse result = mapper.toDetalleResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getDetalles()).hasSize(1);
        assertThat(result.getDetalles().get(0).getId()).isEqualTo(100L);
    }

    @Test
    @DisplayName("toDetalleResponse() con detalles null -> retorna lista vacia")
    void toDetalleResponse_conDetallesNull_retornaListaVacia() {
        entity.setDetalles(null);

        LiquidacionDetalleResponse result = mapper.toDetalleResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getDetalles()).isEmpty();
    }

    // ==== updateEntity ====

    @Test
    @DisplayName("updateEntity() actualiza campos desde request")
    void updateEntity_actualizaCampos() {
        Liquidacion entityToUpdate = new Liquidacion();
        entityToUpdate.setId(1L);

        LiquidacionRequest updateRequest = new LiquidacionRequest();
        updateRequest.setDocTipoId(6L);
        updateRequest.setProveedorId(200L);
        updateRequest.setFechaLiquidacion(LocalDate.of(2026, 6, 1));
        updateRequest.setTipoLiquidacion("C");
        updateRequest.setMonedaId(2L);
        updateRequest.setConceptoFinancieroId(30L);
        updateRequest.setCntblLibroId(40L);
        updateRequest.setImporteNeto(new BigDecimal("8000.00"));
        updateRequest.setTasaCambio(new BigDecimal("3.75"));
        updateRequest.setAnio(2026);
        updateRequest.setMes(6);
        updateRequest.setUsuarioId(2L);
        updateRequest.setObservacion("Actualizado");

        mapper.updateEntity(entityToUpdate, updateRequest);

        assertThat(entityToUpdate.getDocTipoId()).isEqualTo(6L);
        assertThat(entityToUpdate.getProveedorId()).isEqualTo(200L);
        assertThat(entityToUpdate.getFechaLiquidacion()).isEqualTo(LocalDate.of(2026, 6, 1));
        assertThat(entityToUpdate.getTipoLiquidacion()).isEqualTo("C");
        assertThat(entityToUpdate.getImporteNeto()).isEqualByComparingTo(new BigDecimal("8000.00"));
    }
}
