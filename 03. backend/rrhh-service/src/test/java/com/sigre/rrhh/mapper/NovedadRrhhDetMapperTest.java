package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.NovedadRrhhDetRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhDetResponse;
import com.sigre.rrhh.entity.NovedadRrhhDet;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("NovedadRrhhDetMapper — Pruebas Unitarias")
class NovedadRrhhDetMapperTest {

    private final NovedadRrhhDetMapper mapper = Mappers.getMapper(NovedadRrhhDetMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        NovedadRrhhDet entity = RrhhTestFixtures.novedadRrhhDet(1L);
        NovedadRrhhDetResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNovedadRrhhId()).isEqualTo(1L);
        assertThat(response.getFechaProceso()).isEqualTo("2026-01-16");
        assertThat(response.getMontoPlanilla()).isEqualByComparingTo("500.0000");
        assertThat(response.getMontoSeguro()).isEqualByComparingTo("50.0000");
        assertThat(response.getReferenciaDoc()).isEqualTo("REF-001");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<NovedadRrhhDet> entities = List.of(
            RrhhTestFixtures.novedadRrhhDet(1L),
            RrhhTestFixtures.novedadRrhhDet(2L)
        );

        List<NovedadRrhhDetResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad ignorando campos de auditoría y FK")
    void toEntity_convierteDTORequestAEntidad() {
        NovedadRrhhDetRequest request = new NovedadRrhhDetRequest();
        request.setFechaProceso(java.time.LocalDate.of(2026, 3, 1));
        request.setMontoPlanilla(new java.math.BigDecimal("1000.0000"));
        request.setMontoSeguro(new java.math.BigDecimal("100.0000"));
        request.setReferenciaDoc("REF-002");

        NovedadRrhhDet entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getNovedadRrhhId()).isNull();
        assertThat(entity.getFechaProceso()).isEqualTo("2026-03-01");
        assertThat(entity.getMontoPlanilla()).isEqualByComparingTo("1000.0000");
        assertThat(entity.getMontoSeguro()).isEqualByComparingTo("100.0000");
        assertThat(entity.getReferenciaDoc()).isEqualTo("REF-002");
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierte() {
        Instant instant = Instant.parse("2026-06-01T10:00:00Z");
        OffsetDateTime result = mapper.instantToOffsetDateTime(instant);

        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(ZoneOffset.UTC);
    }

    @Test
    @DisplayName("instantToOffsetDateTime() con null -> retorna null")
    void instantToOffsetDateTime_conNull_retornaNull() {
        OffsetDateTime result = mapper.instantToOffsetDateTime(null);
        assertThat(result).isNull();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        NovedadRrhhDetResponse response = mapper.toResponse(null);
        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        List<NovedadRrhhDetResponse> responses = mapper.toResponseList(null);
        assertThat(responses).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        NovedadRrhhDet entity = mapper.toEntity(null);
        assertThat(entity).isNull();
    }
}
