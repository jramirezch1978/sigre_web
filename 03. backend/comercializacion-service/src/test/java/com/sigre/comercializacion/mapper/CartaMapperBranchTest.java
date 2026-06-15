package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.comercializacion.dto.response.CartaResponse;
import com.sigre.comercializacion.entity.Carta;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests de Branch Coverage para CartaMapper
 * Cubre los branches condicionales de los métodos default
 */
class CartaMapperBranchTest {

    private final CartaMapper mapper = Mappers.getMapper(CartaMapper.class);

    @Test
    void formatTimestamp_conNull_retornaNull() {
        String result = mapper.formatTimestamp(null);
        assertThat(result).isNull();
    }

    @Test
    void formatTimestamp_conInstant_retornaStringFormateado() {
        Instant timestamp = Instant.ofEpochSecond(1640995200L); // 2022-01-01 00:00:00 UTC
        String result = mapper.formatTimestamp(timestamp);
        
        assertThat(result).isNotNull();
        assertThat(result).matches("\\d{2}/\\d{2}/\\d{4} \\d{2}:\\d{2}:\\d{2}");
    }

    @Test
    void toResponse_conEntity_retornaResponse() {
        // Given
        Carta entity = new Carta();
        entity.setId(1L);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));

        // When
        CartaResponse response = mapper.toResponse(entity);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getUpdatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getFecModificacion()).isNotNull();
    }

    @Test
    void toResponseList_conLista_retornaListaDeResponses() {
        // Given
        List<Carta> entities = List.of(
                createEntity(1L),
                createEntity(2L)
        );

        // When
        List<CartaResponse> responses = mapper.toResponseList(entities);

        // Then
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    private Carta createEntity(Long id) {
        Carta entity = new Carta();
        entity.setId(id);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        return entity;
    }
}
