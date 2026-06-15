package com.sigre.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.finanzas.dto.request.CntasPagarDetRequest;
import com.sigre.finanzas.dto.response.CntasPagarDetResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;


@DisplayName("Pruebas Unitarias - CntasPagarDetMapper")
class CntasPagarDetMapperTest {

    private CntasPagarDetMapper cntasPagarDetMapper;
    private CntasPagarDet cntasPagarDet;
    private CntasPagarDetRequest cntasPagarDetRequest;

    @BeforeEach
    void setUp() {
        cntasPagarDetMapper = Mappers.getMapper(CntasPagarDetMapper.class);

        CntasPagar cntasPagar = new CntasPagar();
        cntasPagar.setId(1L);

        cntasPagarDet = new CntasPagarDet();
        cntasPagarDet.setId(1L);
        cntasPagarDet.setCntasPagar(cntasPagar);
        cntasPagarDet.setFechaMov(LocalDate.of(2026, 4, 27));
        cntasPagarDet.setTipoMov("REGISTRO");
        cntasPagarDet.setMonto(new BigDecimal("1180.00"));
        cntasPagarDet.setReferencia("Registro inicial factura F001-00001234");
        cntasPagarDet.setConceptoFinancieroId(99L);
        cntasPagarDet.setFlagEstado("1");
        cntasPagarDet.setCreatedBy(10L);
        cntasPagarDet.setFecCreacion(Instant.now());

        cntasPagarDetRequest = new CntasPagarDetRequest();
        cntasPagarDetRequest.setFechaMov(LocalDate.of(2026, 4, 27));
        cntasPagarDetRequest.setTipoMov("REGISTRO");
        cntasPagarDetRequest.setMonto(new BigDecimal("1180.00"));
        cntasPagarDetRequest.setReferencia("Registro inicial factura F001-00001234");
        cntasPagarDetRequest.setConceptoFinancieroId(99L);
    }


    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity - Debe convertir CntasPagarDetRequest a CntasPagarDet entity")
    void toEntity_conRequestValido_retornaEntity() {
        CntasPagarDet entity = cntasPagarDetMapper.toEntity(cntasPagarDetRequest);

        assertThat(entity).isNotNull();
        assertThat(entity.getFechaMov()).isEqualTo(LocalDate.of(2026, 4, 27));
        assertThat(entity.getTipoMov()).isEqualTo("REGISTRO");
        assertThat(entity.getMonto()).isEqualTo(new BigDecimal("1180.00"));
        assertThat(entity.getReferencia()).isEqualTo("Registro inicial factura F001-00001234");
        assertThat(entity.getConceptoFinancieroId()).isEqualTo(99L);
        
        assertThat(entity.getId()).isNull();
        assertThat(entity.getCntasPagar()).isNull();
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }


    // ==== toResponse — escenarios felices ====

    @Test
    @DisplayName("toResponse - Debe convertir CntasPagarDet entity a CntasPagarDetResponse")
    void toResponse_conEntityValida_retornaResponse() {
        CntasPagarDetResponse response = cntasPagarDetMapper.toResponse(cntasPagarDet);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCntasPagarId()).isEqualTo(1L);
        assertThat(response.getFechaMov()).isEqualTo(LocalDate.of(2026, 4, 27));
        assertThat(response.getTipoMov()).isEqualTo("REGISTRO");
        assertThat(response.getMonto()).isEqualTo(new BigDecimal("1180.00"));
        assertThat(response.getReferencia()).isEqualTo("Registro inicial factura F001-00001234");
        assertThat(response.getConceptoFinancieroId()).isEqualTo(99L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(10L);
        assertThat(response.getFecCreacion()).isNotNull();
    }


    // ==== toResponseList — escenarios felices ====

    @Test
    @DisplayName("toResponseList - Debe convertir lista de CntasPagarDet a lista de CntasPagarDetResponse")
    void toResponseList_conListaValida_retornaLista() {
        List<CntasPagarDet> entities = new ArrayList<>();
        entities.add(cntasPagarDet);
        
        CntasPagar cntasPagar = new CntasPagar();
        cntasPagar.setId(1L);
        
        CntasPagarDet detalle2 = new CntasPagarDet();
        detalle2.setId(2L);
        detalle2.setCntasPagar(cntasPagar);
        detalle2.setFechaMov(LocalDate.of(2026, 4, 28));
        detalle2.setTipoMov("PAGO");
        detalle2.setMonto(new BigDecimal("500.00"));
        detalle2.setReferencia("Pago parcial");
        detalle2.setConceptoFinancieroId(100L);
        entities.add(detalle2);

        List<CntasPagarDetResponse> responses = cntasPagarDetMapper.toResponseList(entities);

        assertThat(responses).isNotNull();
        assertThat(responses.size()).isEqualTo(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(0).getTipoMov()).isEqualTo("REGISTRO");
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        assertThat(responses.get(1).getTipoMov()).isEqualTo("PAGO");
    }


    // ==== toEntity — edge cases ====

    @Test
    @DisplayName("toEntity - Debe manejar request con valores nulos")
    void toEntity_conValoresNulos_manejaCorrectamente() {
        CntasPagarDetRequest requestConNulos = new CntasPagarDetRequest();
        requestConNulos.setFechaMov(LocalDate.of(2026, 4, 27));
        requestConNulos.setMonto(new BigDecimal("100.00"));

        CntasPagarDet entity = cntasPagarDetMapper.toEntity(requestConNulos);

        assertThat(entity).isNotNull();
        assertThat(entity.getFechaMov()).isEqualTo(LocalDate.of(2026, 4, 27));
        assertThat(entity.getMonto()).isEqualTo(new BigDecimal("100.00"));
        assertThat(entity.getTipoMov()).isNull();
        assertThat(entity.getReferencia()).isNull();
        assertThat(entity.getConceptoFinancieroId()).isNull();
    }


    // ==== toResponse — edge cases ====

    @Test
    @DisplayName("toResponse - Debe manejar entity con valores nulos")
    void toResponse_conValoresNulos_manejaCorrectamente() {
        CntasPagar cntasPagar = new CntasPagar();
        cntasPagar.setId(1L);
        
        CntasPagarDet entityConNulos = new CntasPagarDet();
        entityConNulos.setId(1L);
        entityConNulos.setCntasPagar(cntasPagar);
        entityConNulos.setMonto(new BigDecimal("100.00"));

        CntasPagarDetResponse response = cntasPagarDetMapper.toResponse(entityConNulos);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCntasPagarId()).isEqualTo(1L);
        assertThat(response.getMonto()).isEqualTo(new BigDecimal("100.00"));
        assertThat(response.getFechaMov()).isNull();
        assertThat(response.getTipoMov()).isNull();
        assertThat(response.getReferencia()).isNull();
    }


    // ==== toResponse — escenarios felices ====

    @Test
    @DisplayName("toResponse - Debe mapear correctamente cntasPagarId desde la relación")
    void toResponse_conRelacionValida_mapeaCntasPagarId() {
        CntasPagar cntasPagar = new CntasPagar();
        cntasPagar.setId(99L);
        
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setId(1L);
        detalle.setCntasPagar(cntasPagar);
        detalle.setMonto(new BigDecimal("1000.00"));

        CntasPagarDetResponse response = cntasPagarDetMapper.toResponse(detalle);

        assertThat(response).isNotNull();
        assertThat(response.getCntasPagarId()).isEqualTo(99L);
    }


    // ==== toResponseList — escenarios felices ====

    @Test
    @DisplayName("toResponseList - Debe manejar lista vacía")
    void toResponseList_conListaVacia_retornaListaVacia() {
        List<CntasPagarDet> entities = new ArrayList<>();

        List<CntasPagarDetResponse> responses = cntasPagarDetMapper.toResponseList(entities);

        assertThat(responses).isNotNull();
        assertThat(responses.isEmpty()).isTrue();
    }

    // ==== Null edge cases ====

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(cntasPagarDetMapper.toEntity(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        assertThat(cntasPagarDetMapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(cntasPagarDetMapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toResponse() con entity sin cntasPagar -> cntasPagarId null")
    void toResponse_conEntitySinCntasPagar_cntasPagarIdNull() {
        CntasPagarDet detalle = new CntasPagarDet();
        detalle.setId(2L);

        CntasPagarDetResponse response = cntasPagarDetMapper.toResponse(detalle);

        assertThat(response).isNotNull();
        assertThat(response.getCntasPagarId()).isNull();
    }
}
