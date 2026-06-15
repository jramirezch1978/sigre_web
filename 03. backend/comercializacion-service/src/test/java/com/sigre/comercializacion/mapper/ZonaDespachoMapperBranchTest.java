package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import com.sigre.comercializacion.dto.request.ZonaDespachoRequest;
import com.sigre.comercializacion.dto.response.ZonaDespachoResponse;
import com.sigre.comercializacion.entity.ZonaDespacho;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests de Branch Coverage para ZonaDespachoMapper
 * Cubre todos los branches condicionales de los métodos default
 */
class ZonaDespachoMapperBranchTest {

    private final ZonaDespachoMapper mapper = Mappers.getMapper(ZonaDespachoMapper.class);

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
        ZonaDespachoRequest request = new ZonaDespachoRequest();
        request.setZonaDespacho("ZONA-001");
        request.setDescZonaDespacho("Zona de despacho");
        request.setUbigeo("150101");

        // When
        ZonaDespacho entity = mapper.toEntity(request);

        // Then
        assertThat(entity).isNotNull();
        assertThat(entity.getZonaDespacho()).isEqualTo("ZONA-001");
        assertThat(entity.getDescZonaDespacho()).isEqualTo("Zona de despacho");
        assertThat(entity.getUbigeo()).isEqualTo("150101");
    }

    @Test
    void toResponse_conEntity_retornaResponse() {
        // Given
        ZonaDespacho entity = new ZonaDespacho();
        entity.setId(1L);
        entity.setZonaDespacho("ZONA-001");
        entity.setDescZonaDespacho("Zona de despacho");
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));

        // When
        ZonaDespachoResponse response = mapper.toResponse(entity);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getZonaDespacho()).isEqualTo("ZONA-001");
        assertThat(response.getDescZonaDespacho()).isEqualTo("Zona de despacho");
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
        List<ZonaDespacho> entities = List.of(
                createEntity(1L, "ZONA-001"),
                createEntity(2L, "ZONA-002")
        );

        // When
        List<ZonaDespachoResponse> responses = mapper.toResponseList(entities);

        // Then
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(0).getZonaDespacho()).isEqualTo("ZONA-001");
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        assertThat(responses.get(1).getZonaDespacho()).isEqualTo("ZONA-002");
    }

    @Test
    void updateEntity_conRequest_actualizaEntity() {
        // Given
        ZonaDespacho entity = createEntity(1L, "ZONA-ORIGINAL");
        ZonaDespachoRequest request = new ZonaDespachoRequest();
        request.setZonaDespacho("ZONA-ACTUALIZADA");
        request.setDescZonaDespacho("Descripción actualizada");
        request.setUbigeo("150102");

        // When
        mapper.updateEntity(request, entity);

        // Then
        assertThat(entity.getZonaDespacho()).isEqualTo("ZONA-ACTUALIZADA");
        assertThat(entity.getDescZonaDespacho()).isEqualTo("Descripción actualizada");
        assertThat(entity.getUbigeo()).isEqualTo("150102");
        // Los campos de auditoría no deben cambiar
        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    private ZonaDespacho createEntity(Long id, String zonaDespacho) {
        ZonaDespacho entity = new ZonaDespacho();
        entity.setId(id);
        entity.setZonaDespacho(zonaDespacho);
        entity.setDescZonaDespacho("Descripción de " + zonaDespacho);
        entity.setUbigeo("150101");
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        return entity;
    }
}
