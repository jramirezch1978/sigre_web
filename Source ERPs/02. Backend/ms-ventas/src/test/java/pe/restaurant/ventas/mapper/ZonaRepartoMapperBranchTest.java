package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.dto.request.ZonaRepartoRequest;
import pe.restaurant.ventas.dto.response.ZonaRepartoResponse;
import pe.restaurant.ventas.entity.ZonaReparto;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests de Branch Coverage para ZonaRepartoMapper
 * Cubre todos los branches condicionales de los métodos default
 */
class ZonaRepartoMapperBranchTest {

    private final ZonaRepartoMapper mapper = Mappers.getMapper(ZonaRepartoMapper.class);

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
    void toEntity_conRequest_retornaEntity() {
        // Given
        ZonaRepartoRequest request = new ZonaRepartoRequest();
        request.setZonaReparto("ZONA-001");
        request.setDescZonaReparto("Zona de reparto");
        request.setUbigeo("150101");

        // When
        ZonaReparto entity = mapper.toEntity(request);

        // Then
        assertThat(entity).isNotNull();
        assertThat(entity.getZonaReparto()).isEqualTo("ZONA-001");
        assertThat(entity.getDescZonaReparto()).isEqualTo("Zona de reparto");
        assertThat(entity.getUbigeo()).isEqualTo("150101");
    }

    @Test
    void toResponse_conEntity_retornaResponse() {
        // Given
        ZonaReparto entity = new ZonaReparto();
        entity.setId(1L);
        entity.setZonaReparto("ZONA-001");
        entity.setDescZonaReparto("Zona de reparto");
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));

        // When
        ZonaRepartoResponse response = mapper.toResponse(entity);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getZonaReparto()).isEqualTo("ZONA-001");
        assertThat(response.getDescZonaReparto()).isEqualTo("Zona de reparto");
        assertThat(response.getUbigeo()).isEqualTo("150101");
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getUpdatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getFecModificacion()).isNotNull();
    }

    @Test
    void toResponseList_conLista_retornaListaDeResponses() {
        // Given
        List<ZonaReparto> entities = List.of(
                createEntity(1L, "ZONA-001"),
                createEntity(2L, "ZONA-002")
        );

        // When
        List<ZonaRepartoResponse> responses = mapper.toResponseList(entities);

        // Then
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(0).getZonaReparto()).isEqualTo("ZONA-001");
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        assertThat(responses.get(1).getZonaReparto()).isEqualTo("ZONA-002");
    }

    private ZonaReparto createEntity(Long id, String zonaReparto) {
        ZonaReparto entity = new ZonaReparto();
        entity.setId(id);
        entity.setZonaReparto(zonaReparto);
        entity.setDescZonaReparto("Descripción de " + zonaReparto);
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        return entity;
    }
}
