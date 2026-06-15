package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.response.GratificacionResponse;
import com.sigre.rrhh.entity.Gratificacion;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("GratificacionMapper — Pruebas Unitarias")
class GratificacionMapperTest {

    private final GratificacionMapper mapper = Mappers.getMapper(GratificacionMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        Gratificacion entity = RrhhTestFixtures.gratificacion(1L);

        GratificacionResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getAnio()).isEqualTo(2026);
        assertThat(response.getPeriodoGratificacionId()).isEqualTo(1L);
        assertThat(response.getRemuneracionComputable()).isEqualByComparingTo(new BigDecimal("3000.0000"));
        assertThat(response.getMesesLaborados()).isEqualTo(6);
        assertThat(response.getMontoGratificacion()).isEqualByComparingTo(new BigDecimal("1500.0000"));
        assertThat(response.getBonificacionExtraordinaria()).isEqualByComparingTo(new BigDecimal("135.0000"));
        assertThat(response.getTotal()).isEqualByComparingTo(new BigDecimal("1635.0000"));
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<Gratificacion> entities = List.of(
                RrhhTestFixtures.gratificacion(1L),
                RrhhTestFixtures.gratificacion(2L)
        );

        List<GratificacionResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toResponse() -> mapea createdBy como String")
    void toResponse_mapeaCreatedByComoString() {
        Gratificacion entity = RrhhTestFixtures.gratificacion(1L);

        GratificacionResponse response = mapper.toResponse(entity);

        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponse() -> convierte Instant a OffsetDateTime")
    void toResponse_convierteInstantAOffsetDateTime() {
        Gratificacion entity = RrhhTestFixtures.gratificacion(1L);

        GratificacionResponse response = mapper.toResponse(entity);

        assertThat(response.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse(null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierteInstantAOffsetDateTime() {
        java.time.Instant instant = java.time.Instant.parse("2023-01-01T12:00:00Z");

        java.time.OffsetDateTime result = mapper.instantToOffsetDateTime(instant);

        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(java.time.ZoneOffset.UTC);
    }

    @Test
    @DisplayName("instantToOffsetDateTime() con null -> retorna null")
    void instantToOffsetDateTime_conNull_retornaNull() {
        assertThat(mapper.instantToOffsetDateTime(null)).isNull();
    }
}
