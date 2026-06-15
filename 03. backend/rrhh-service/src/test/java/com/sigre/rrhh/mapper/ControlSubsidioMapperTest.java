package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.ControlSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.ControlSubsidioResponse;
import com.sigre.rrhh.entity.ControlSubsidio;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("ControlSubsidioMapper — Pruebas Unitarias")
class ControlSubsidioMapperTest {

    private final ControlSubsidioMapper mapper = Mappers.getMapper(ControlSubsidioMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        ControlSubsidio entity = RrhhTestFixtures.controlSubsidio(1L);

        ControlSubsidioResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTipoSubsidioId()).isEqualTo(1L);
        assertThat(response.getMontoSubsidio()).isEqualByComparingTo("500.0000");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteLista() {
        List<ControlSubsidio> entities = List.of(
                RrhhTestFixtures.controlSubsidio(1L),
                RrhhTestFixtures.controlSubsidio(2L)
        );

        List<ControlSubsidioResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
    }

    @Test
    @DisplayName("toEntity() -> convierte CreateRequest a entidad ignorando auditoría")
    void toEntity_convierteCreateRequestAEntidad() {
        ControlSubsidioCreateRequest request = RrhhTestFixtures.controlSubsidioCreateRequest();

        ControlSubsidio entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getTipoSubsidioId()).isEqualTo(1L);
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza solo campos editables")
    void updateEntity_actualizaCamposEditables() {
        ControlSubsidioUpdateRequest request = RrhhTestFixtures.controlSubsidioUpdateRequest();
        ControlSubsidio entity = RrhhTestFixtures.controlSubsidio(1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getMontoSubsidio()).isEqualByComparingTo("700.0000");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
    }

    @Test
    @DisplayName("métodos con null -> retornan null")
    void metodosConNull_retornanNull() {
        assertThat(mapper.toResponse(null)).isNull();
        assertThat(mapper.toResponseList(null)).isNull();
        assertThat(mapper.toEntity(null)).isNull();
    }
}
