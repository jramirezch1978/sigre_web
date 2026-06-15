package com.sigre.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.finanzas.dto.request.DetraccionRequest;
import com.sigre.finanzas.dto.response.DetraccionResponse;
import com.sigre.finanzas.entity.Detraccion;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@DisplayName("Pruebas Unitarias - DetraccionMapper")
class DetraccionMapperTest {

    private DetraccionMapper mapper;
    private Detraccion entity;
    private DetraccionRequest request;

    @BeforeEach
    void setUp() {
        mapper = Mappers.getMapper(DetraccionMapper.class);

        entity = new Detraccion();
        entity.setId(1L);
        entity.setCntasPagarId(100L);
        entity.setNroDetraccion("DET-001");
        entity.setFechaRegistro(LocalDate.of(2026, 5, 1));
        entity.setImporte(new BigDecimal("500.00"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        request = new DetraccionRequest();
        request.setCntasPagarId(100L);
        request.setNroDetraccion("DET-001");
        request.setFechaRegistro(LocalDate.of(2026, 5, 1));
        request.setImporte(new BigDecimal("500.00"));
    }

    // ==== toEntity — escenarios felices ====

    @Test
    @DisplayName("toEntity() con request valido -> retorna entity")
    void toEntity_conRequestValido_retornaEntity() {
        Detraccion result = mapper.toEntity(request);

        assertThat(result).isNotNull();
        assertThat(result.getCntasPagarId()).isEqualTo(100L);
        assertThat(result.getNroDetraccion()).isEqualTo("DET-001");
        assertThat(result.getFechaRegistro()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(result.getImporte()).isEqualByComparingTo(new BigDecimal("500.00"));
    }

    // ==== toEntity — edge cases ====

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }

    // ==== toResponse — escenarios felices ====

    @Test
    @DisplayName("toResponse() con entity valida -> retorna response")
    void toResponse_conEntityValida_retornaResponse() {
        DetraccionResponse result = mapper.toResponse(entity);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCntasPagarId()).isEqualTo(100L);
        assertThat(result.getNroDetraccion()).isEqualTo("DET-001");
        assertThat(result.getFechaRegistro()).isEqualTo(LocalDate.of(2026, 5, 1));
        assertThat(result.getImporte()).isEqualByComparingTo(new BigDecimal("500.00"));
    }

    // ==== toResponse — edge cases ====

    @Test
    @DisplayName("toResponse() con entity null -> retorna null")
    void toResponse_conEntityNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    // ==== toResponseList ====

    @Test
    @DisplayName("toResponseList() con lista valida -> retorna lista")
    void toResponseList_conListaValida_retornaLista() {
        List<DetraccionResponse> result = mapper.toResponseList(List.of(entity, entity));

        assertThat(result).hasSize(2);
        assertThat(result.get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("toResponseList() con lista vacia -> retorna lista vacia")
    void toResponseList_conListaVacia_retornaListaVacia() {
        assertThat(mapper.toResponseList(new ArrayList<>())).isEmpty();
    }
}
