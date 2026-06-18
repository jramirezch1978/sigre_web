package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.PermisoLicenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.PermisoLicenciaResponse;
import pe.restaurant.rrhh.entity.PermisoLicencia;

import java.time.Instant;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("PermisoLicenciaMapper — Pruebas Unitarias")
class PermisoLicenciaMapperTest {

    private final PermisoLicenciaMapper mapper = Mappers.getMapper(PermisoLicenciaMapper.class);

    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);

        PermisoLicenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getTipoSuspensionLaboralId()).isEqualTo(1L);
        assertThat(response.getFechaInicio()).isEqualTo(LocalDate.of(2026, 1, 15));
        assertThat(response.getCreatedBy()).isEqualTo("1");
    }

    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<PermisoLicencia> entities = List.of(
            RrhhTestFixtures.permisoLicencia(1L),
            RrhhTestFixtures.permisoLicencia(2L)
        );

        List<PermisoLicenciaResponse> responses = mapper.toResponseList(entities);

        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(1).getId()).isEqualTo(2L);
    }

    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad")
    void toEntity_convierteDTORequestAEntidad() {
        PermisoLicenciaCreateRequest request = RrhhTestFixtures.permisoLicenciaCreateRequest();

        PermisoLicencia entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getTipoSuspensionLaboralId()).isEqualTo(1L);
        assertThat(entity.getFechaInicio()).isEqualTo(LocalDate.of(2026, 1, 15));
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente sin modificar ID ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        PermisoLicenciaUpdateRequest request = RrhhTestFixtures.permisoLicenciaUpdateRequest();
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getFechaFin()).isEqualTo(LocalDate.of(2026, 1, 20));
        assertThat(entity.getDias()).isEqualTo(5);
        assertThat(entity.getFlagEstado()).isEqualTo("1");
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierteInstantAOffsetDateTime() {
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
        PermisoLicenciaResponse response = mapper.toResponse(null);

        assertThat(response).isNull();
    }

    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        List<PermisoLicenciaResponse> responses = mapper.toResponseList(null);

        assertThat(responses).isNull();
    }

    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        PermisoLicencia entity = mapper.toEntity(null);

        assertThat(entity).isNull();
    }
}
