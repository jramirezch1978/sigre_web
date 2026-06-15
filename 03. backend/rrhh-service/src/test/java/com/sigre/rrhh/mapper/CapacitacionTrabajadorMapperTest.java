package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.dto.request.CapacitacionTrabajadorRequest;
import com.sigre.rrhh.dto.response.CapacitacionTrabajadorResponse;
import com.sigre.rrhh.entity.CapacitacionTrabajador;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("CapacitacionTrabajadorMapper — Pruebas Unitarias")
class CapacitacionTrabajadorMapperTest {

    private final CapacitacionTrabajadorMapper mapper = Mappers.getMapper(CapacitacionTrabajadorMapper.class);

    @Test
    @DisplayName("toResponse() convierte entidad a DTO")
    void toResponse_convierteEntidadADTO() {
        CapacitacionTrabajador entity = new CapacitacionTrabajador();
        entity.setId(1L);
        entity.setCapacitacionId(10L);
        entity.setTrabajadorId(100L);
        entity.setAsistio(true);
        entity.setCalificacion(java.math.BigDecimal.valueOf(15.5));
        entity.setCertificado(true);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.parse("2026-01-15T10:00:00Z"));

        CapacitacionTrabajadorResponse response = mapper.toResponse(entity);

        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getCapacitacionId()).isEqualTo(10L);
        assertThat(response.getTrabajadorId()).isEqualTo(100L);
        assertThat(response.getAsistio()).isTrue();
        assertThat(response.getCertificado()).isTrue();
    }

    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        assertThat(mapper.toResponse((CapacitacionTrabajador) null)).isNull();
    }

    @Test
    @DisplayName("toResponseList() convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaADTOs() {
        CapacitacionTrabajador e1 = new CapacitacionTrabajador();
        e1.setId(1L);
        CapacitacionTrabajador e2 = new CapacitacionTrabajador();
        e2.setId(2L);

        List<CapacitacionTrabajadorResponse> responses = mapper.toResponseList(List.of(e1, e2));

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        assertThat(mapper.toResponseList(null)).isNull();
    }

    @Test
    @DisplayName("toEntity() convierte request a entidad")
    void toEntity_convierteRequestAEntidad() {
        CapacitacionTrabajadorRequest request = new CapacitacionTrabajadorRequest();
        request.setTrabajadorId(2L);
        request.setAsistio(true);
        request.setCalificacion(java.math.BigDecimal.valueOf(18));
        request.setCertificado(false);

        CapacitacionTrabajador entity = mapper.toEntity(request);

        assertThat(entity).isNotNull();
        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(2L);
        assertThat(entity.getAsistio()).isTrue();
        assertThat(entity.getCertificado()).isFalse();
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        assertThat(mapper.toEntity(null)).isNull();
    }
}
