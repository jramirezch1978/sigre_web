package com.sigre.rrhh.mapper;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.PermisoLicenciaCreateRequest;
import com.sigre.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import com.sigre.rrhh.dto.response.PermisoLicenciaResponse;
import com.sigre.rrhh.entity.PermisoLicencia;
import com.sigre.rrhh.repository.PermisoLicenciaDetRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PermisoLicenciaMapper — Pruebas Unitarias")
class PermisoLicenciaMapperTest {

    @Mock
    private PermisoLicenciaDetRepository detRepository;

    @Mock
    private PermisoLicenciaDetMapper detMapper;

    @InjectMocks
    private PermisoLicenciaMapperImpl mapper;

    @BeforeEach
    void setUp() {
        when(detRepository.findByPermisoLicenciaIdOrderByItemAsc(anyLong()))
                .thenAnswer(inv -> List.of(RrhhTestFixtures.permisoLicenciaDet(10L, inv.getArgument(0))));
        when(detMapper.toResponseList(org.mockito.ArgumentMatchers.anyList()))
                .thenAnswer(inv -> List.of());
    }

    @Test
    @DisplayName("toResponse() -> convierte cabecera y enriquece con detalle")
    void toResponse_convierteEntidadADTORespuesta() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);

        PermisoLicenciaResponse response = mapper.toResponse(entity);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getTrabajadorId()).isEqualTo(1L);
        assertThat(response.getConceptoPlanillaId()).isEqualTo(1L);
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
    @DisplayName("toEntity() -> convierte DTO request a cabecera")
    void toEntity_convierteDTORequestAEntidad() {
        PermisoLicenciaCreateRequest request = RrhhTestFixtures.permisoLicenciaCreateRequest();

        PermisoLicencia entity = mapper.toEntity(request);

        assertThat(entity.getId()).isNull();
        assertThat(entity.getTrabajadorId()).isEqualTo(1L);
        assertThat(entity.getConceptoPlanillaId()).isNull();
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }

    @Test
    @DisplayName("updateEntity() -> actualiza cabecera sin modificar ID ni auditoría")
    void updateEntity_actualizaEntidadExistente() {
        PermisoLicenciaUpdateRequest request = RrhhTestFixtures.permisoLicenciaUpdateRequest();
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(Instant.now());

        mapper.updateEntity(entity, request);

        assertThat(entity.getId()).isEqualTo(1L);
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
