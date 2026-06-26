package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.dto.request.ZonaVentaRequest;
import pe.restaurant.ventas.dto.response.ZonaVentaResponse;
import pe.restaurant.ventas.entity.ZonaVenta;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests de Branch Coverage para ZonaVentaMapper
 * Cubre todos los branches condicionales de los métodos default
 */
class ZonaVentaMapperBranchTest {

    private final ZonaVentaMapper mapper = Mappers.getMapper(ZonaVentaMapper.class);

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
        ZonaVentaRequest request = new ZonaVentaRequest();
        request.setZonaVenta("ZONA-001");
        request.setDescZonaVenta("Zona de prueba");
        request.setUbigeo("150101");

        // When
        ZonaVenta entity = mapper.toEntity(request);

        // Then
        assertThat(entity).isNotNull();
        assertThat(entity.getZonaVenta()).isEqualTo("ZONA-001");
        assertThat(entity.getDescZonaVenta()).isEqualTo("Zona de prueba");
        assertThat(entity.getUbigeo()).isEqualTo("150101");
    }

    @Test
    void toResponse_conEntity_retornaResponse() {
        // Given
        ZonaVenta entity = new ZonaVenta();
        entity.setId(1L);
        entity.setZonaVenta("ZONA-001");
        entity.setDescZonaVenta("Zona de prueba");
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));

        // When
        ZonaVentaResponse response = mapper.toResponse(entity);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getZonaVenta()).isEqualTo("ZONA-001");
        assertThat(response.getDescZonaVenta()).isEqualTo("Zona de prueba");
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
        List<ZonaVenta> entities = List.of(
                createEntity(1L, "ZONA-001"),
                createEntity(2L, "ZONA-002")
        );

        // When
        List<ZonaVentaResponse> responses = mapper.toResponseList(entities);

        // Then
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(0).getZonaVenta()).isEqualTo("ZONA-001");
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        assertThat(responses.get(1).getZonaVenta()).isEqualTo("ZONA-002");
    }

    @Test
    void updateEntity_conRequest_actualizaEntity() {
        // Given
        ZonaVenta entity = createEntity(1L, "ZONA-ORIGINAL");
        ZonaVentaRequest request = new ZonaVentaRequest();
        request.setZonaVenta("ZONA-ACTUALIZADA");
        request.setDescZonaVenta("Descripción actualizada");
        request.setUbigeo("150102");

        // When
        mapper.updateEntity(request, entity);

        // Then
        assertThat(entity.getZonaVenta()).isEqualTo("ZONA-ACTUALIZADA");
        assertThat(entity.getDescZonaVenta()).isEqualTo("Descripción actualizada");
        assertThat(entity.getUbigeo()).isEqualTo("150102");
        // Los campos de auditoría no deben cambiar
        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    private ZonaVenta createEntity(Long id, String zonaVenta) {
        ZonaVenta entity = new ZonaVenta();
        entity.setId(id);
        entity.setZonaVenta(zonaVenta);
        entity.setDescZonaVenta("Descripción de " + zonaVenta);
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        return entity;
    }
}
