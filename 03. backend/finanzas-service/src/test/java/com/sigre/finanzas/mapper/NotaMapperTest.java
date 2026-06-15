package com.sigre.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import com.sigre.finanzas.dto.request.NotaDetalleRequest;
import com.sigre.finanzas.dto.request.NotaRequest;
import com.sigre.finanzas.dto.response.NotaResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;
import com.sigre.finanzas.enums.TipoNota;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@DisplayName("NotaMapper — Pruebas Unitarias")
class NotaMapperTest {

    private NotaMapper mapper;
    private CntasPagar entityFull;
    private NotaRequest requestFull;

    @BeforeEach
    void setUp() {
        mapper = new NotaMapper();

        entityFull = new CntasPagar();
        entityFull.setId(1L);
        entityFull.setSucursalId(1L);
        entityFull.setProveedorId(4L);
        entityFull.setDocTipoId(1L);
        entityFull.setSerie("N001");
        entityFull.setNumero("00000123");
        entityFull.setFechaEmision(LocalDate.of(2026, 5, 1));
        entityFull.setFechaVencimiento(LocalDate.of(2026, 6, 1));
        entityFull.setMonedaId(1L);
        entityFull.setTotal(new BigDecimal("500.00"));
        entityFull.setSaldo(new BigDecimal("500.00"));
        entityFull.setCntblAsientoId(10L);
        entityFull.setFlagEstado("1");
        entityFull.setCreatedBy(100L);
        entityFull.setFecCreacion(Instant.parse("2026-05-01T10:00:00Z"));
        entityFull.setUpdatedBy(101L);
        entityFull.setFecModificacion(Instant.parse("2026-05-02T12:00:00Z"));

        CntasPagarDet det = new CntasPagarDet();
        det.setId(1L);
        det.setCntasPagar(entityFull);
        det.setItem(1);
        det.setConceptoFinancieroId(42L);
        det.setDescripcion("Nota de debito");
        det.setCantidad(new BigDecimal("1.0000"));
        det.setPrecioUnitario(new BigDecimal("500.0000000"));
        det.setMonto(new BigDecimal("500.0000"));
        det.setFechaMov(LocalDate.of(2026, 5, 1));
        det.setTipoMov("NOTA");
        det.setReferencia("ND-001");
        det.setFlagEstado("1");
        det.setCreatedBy(100L);
        det.setFecCreacion(Instant.parse("2026-05-01T10:00:00Z"));
        entityFull.setDetalles(new ArrayList<>(List.of(det)));

        requestFull = new NotaRequest();
        requestFull.setTipoNota(TipoNota.DEBITO);
        requestFull.setProveedorId(4L);
        requestFull.setDocTipoId(1L);
        requestFull.setSerie("N001");
        requestFull.setNumero("00000123");
        requestFull.setFechaEmision(LocalDate.of(2026, 5, 1));
        requestFull.setFechaVencimiento(LocalDate.of(2026, 6, 1));
        requestFull.setMonedaId(1L);
        requestFull.setTotal(new BigDecimal("500.00"));
        requestFull.setDetalles(new ArrayList<>());
    }

    // ==== toResponse — escenarios felices ====

    @Test
    @DisplayName("toResponse() con entity llena y detalles -> retorna NotaResponse completo")
    void toResponse_conEntityLlena_retornaResponse() {
        NotaResponse result = mapper.toResponse(entityFull);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getSucursalId()).isEqualTo(1L);
        assertThat(result.getProveedorId()).isEqualTo(4L);
        assertThat(result.getDocTipoId()).isEqualTo(1L);
        assertThat(result.getSerie()).isEqualTo("N001");
        assertThat(result.getNumero()).isEqualTo("00000123");
        assertThat(result.getFechaEmision()).isNotNull();
        assertThat(result.getFechaVencimiento()).isNotNull();
        assertThat(result.getMonedaId()).isEqualTo(1L);
        assertThat(result.getTotal()).isEqualTo(new BigDecimal("500.00"));
        assertThat(result.getSaldo()).isEqualTo(new BigDecimal("500.00"));
        assertThat(result.getCntblAsientoId()).isEqualTo(10L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(100L);
        assertThat(result.getFecCreacion()).isNotNull();
        assertThat(result.getUpdatedBy()).isEqualTo(101L);
        assertThat(result.getFecModificacion()).isNotNull();
        assertThat(result.getDetalles()).isNotNull().hasSize(1);
    }

    @Test
    @DisplayName("toResponse() con entity sin detalles -> retorna NotaResponse sin detalles")
    void toResponse_conEntitySinDetalles_retornaResponseSinDetalles() {
        entityFull.setDetalles(new ArrayList<>());

        NotaResponse result = mapper.toResponse(entityFull);

        assertThat(result).isNotNull();
        assertThat(result.getDetalles()).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity sin fechas -> retorna NotaResponse con fechas nulas")
    void toResponse_conEntitySinFechas_retornaResponseConFechasNulas() {
        entityFull.setFechaEmision(null);
        entityFull.setFechaVencimiento(null);
        entityFull.setFecCreacion(null);
        entityFull.setFecModificacion(null);
        entityFull.setDetalles(new ArrayList<>());

        NotaResponse result = mapper.toResponse(entityFull);

        assertThat(result).isNotNull();
        assertThat(result.getFechaEmision()).isNull();
        assertThat(result.getFechaVencimiento()).isNull();
        assertThat(result.getFecCreacion()).isNull();
        assertThat(result.getFecModificacion()).isNull();
    }

    // ==== toResponse — edge cases ====

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        NotaResponse result = mapper.toResponse(null);

        assertThat(result).isNull();
    }

    // ==== toResponseList — escenarios felices ====

    @Test
    @DisplayName("toResponseList() con lista valida de 2 entities -> retorna lista de 2 NotaResponse")
    void toResponseList_conListaValida_retornaLista() {
        CntasPagar entity2 = new CntasPagar();
        entity2.setId(2L);
        entity2.setSerie("N002");
        entity2.setNumero("00000222");
        entity2.setDetalles(new ArrayList<>());
        entity2.setTotal(BigDecimal.ZERO);
        entity2.setSaldo(BigDecimal.ZERO);
        entity2.setFechaEmision(LocalDate.of(2026, 5, 10));
        entity2.setFlagEstado("1");

        List<CntasPagar> entities = List.of(entityFull, entity2);

        List<NotaResponse> results = mapper.toResponseList(entities);

        assertThat(results).isNotNull().hasSize(2);
        assertThat(results.get(0).getId()).isEqualTo(1L);
        assertThat(results.get(0).getSerie()).isEqualTo("N001");
        assertThat(results.get(1).getId()).isEqualTo(2L);
        assertThat(results.get(1).getSerie()).isEqualTo("N002");
    }

    // ==== toResponseList — edge cases ====

    @Test
    @DisplayName("toResponseList() con lista vacia -> retorna lista vacia")
    void toResponseList_conListaVacia_retornaListaVacia() {
        List<NotaResponse> results = mapper.toResponseList(Collections.emptyList());

        assertThat(results).isNotNull().isEmpty();
    }

    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity() con request parametros validos -> retorna CntasPagar entity")
    void toEntity_conRequestValido_retornaEntity() {
        CntasPagar result = mapper.toEntity(requestFull, 1L, 10L);

        assertThat(result).isNotNull();
        assertThat(result.getSucursalId()).isEqualTo(1L);
        assertThat(result.getProveedorId()).isEqualTo(4L);
        assertThat(result.getDocTipoId()).isEqualTo(1L);
        assertThat(result.getSerie()).isEqualTo("N001");
        assertThat(result.getNumero()).isEqualTo("00000123");
        assertThat(result.getFechaEmision()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(result.getFechaVencimiento()).isEqualTo(LocalDate.of(2026, 6, 1));
        assertThat(result.getMonedaId()).isEqualTo(1L);
        assertThat(result.getTotal()).isEqualTo(new BigDecimal("500.00"));
        assertThat(result.getSaldo()).isEqualTo(new BigDecimal("500.00"));
        assertThat(result.getCntblAsientoId()).isEqualTo(10L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getId()).isNull();
    }

    @Test
    @DisplayName("toEntity() con request de tipo CREDITO -> retorna entity con flagEstado activo")
    void toEntity_conTipoCredito_retornaEntity() {
        requestFull.setTipoNota(TipoNota.CREDITO);

        CntasPagar result = mapper.toEntity(requestFull, 2L, 20L);

        assertThat(result).isNotNull();
        assertThat(result.getSucursalId()).isEqualTo(2L);
        assertThat(result.getCntblAsientoId()).isEqualTo(20L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    // ==== toEntity — edge cases ====

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        CntasPagar result = mapper.toEntity(null, 1L, 10L);

        assertThat(result).isNull();
    }

    @Test
    @DisplayName("toEntity() con request sin fecha vencimiento -> asigna fecha vencimiento nula")
    void toEntity_conRequestSinFechaVencimiento_asignaFechas() {
        requestFull.setFechaVencimiento(null);

        CntasPagar result = mapper.toEntity(requestFull, 1L, 10L);

        assertThat(result).isNotNull();
        assertThat(result.getFechaEmision()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(result.getFechaVencimiento()).isNull();
    }
}
