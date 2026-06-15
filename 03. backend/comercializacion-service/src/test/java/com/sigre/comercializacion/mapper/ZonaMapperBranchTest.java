package com.sigre.comercializacion.mapper;

import org.junit.jupiter.api.Test;
import com.sigre.comercializacion.dto.request.ZonaRequest;
import com.sigre.comercializacion.dto.response.ZonaResponse;
import com.sigre.comercializacion.entity.Zona;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests de Branch Coverage para ZonaMapper
 * Cubre todos los branches condicionales de los métodos default
 */
class ZonaMapperBranchTest {

    @Test
    void createSucursalFromRequest_conNull_retornaNull() {
        Zona.Sucursal result = ZonaMapper.INSTANCE.createSucursalFromRequest(null);
        assertThat(result).isNull();
    }

    @Test
    void createSucursalFromRequest_conIdValido_retornaSucursal() {
        // When
        Zona.Sucursal result = ZonaMapper.INSTANCE.createSucursalFromRequest(1L);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    void formatTimestamp_conNull_retornaNull() {
        String result = ZonaMapper.INSTANCE.formatTimestamp(null);
        assertThat(result).isNull();
    }

    @Test
    void formatTimestamp_conInstant_retornaStringFormateado() {
        Instant timestamp = Instant.ofEpochSecond(1640995200L); // 2022-01-01 00:00:00 UTC
        String result = ZonaMapper.INSTANCE.formatTimestamp(timestamp);
        
        assertThat(result).isNotNull();
        assertThat(result).matches("\\d{2}/\\d{2}/\\d{4} \\d{2}:\\d{2}:\\d{2}");
    }

    @Test
    void toEntity_conRequest_retornaEntity() {
        // Given
        ZonaRequest request = new ZonaRequest();
        request.setNombre("ZONA-001");
        request.setCapacidad(50);
        request.setSucursalId(1L);

        // When
        Zona entity = ZonaMapper.INSTANCE.toEntity(request);

        // Then
        assertThat(entity).isNotNull();
        assertThat(entity.getNombre()).isEqualTo("ZONA-001");
        assertThat(entity.getCapacidad()).isEqualTo(50);
        assertThat(entity.getSucursal()).isNotNull();
        assertThat(entity.getSucursal().getId()).isEqualTo(1L);
    }

    @Test
    void toResponse_conEntity_retornaResponse() {
        // Given
        Zona entity = new Zona();
        entity.setId(1L);
        entity.setNombre("ZONA-001");
        entity.setCapacidad(50);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        
        // Crear sucursal
        Zona.Sucursal sucursal = new Zona.Sucursal();
        sucursal.setId(1L);
        sucursal.setNombre("SUCURSAL PRINCIPAL");
        entity.setSucursal(sucursal);

        // When
        ZonaResponse response = ZonaMapper.INSTANCE.toResponse(entity);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("ZONA-001");
        assertThat(response.getCapacidad()).isEqualTo(50);
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getUpdatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getFecModificacion()).isNotNull();
        assertThat(response.getSucursalId()).isEqualTo(1L);
        assertThat(response.getSucursalNombre()).isEqualTo("SUCURSAL PRINCIPAL");
    }

    @Test
    void toResponseList_conLista_retornaListaDeResponses() {
        // Given
        List<Zona> entities = List.of(
                createEntity(1L, "ZONA-001"),
                createEntity(2L, "ZONA-002")
        );

        // When
        List<ZonaResponse> responses = ZonaMapper.INSTANCE.toResponseList(entities);

        // Then
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(0).getNombre()).isEqualTo("ZONA-001");
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        assertThat(responses.get(1).getNombre()).isEqualTo("ZONA-002");
    }

    @Test
    void updateEntity_conRequest_actualizaEntity() {
        // Given
        Zona entity = createEntity(1L, "ZONA-ORIGINAL");
        ZonaRequest request = new ZonaRequest();
        request.setNombre("ZONA-ACTUALIZADA");
        request.setCapacidad(60);

        // When
        ZonaMapper.INSTANCE.updateEntity(request, entity);

        // Then
        assertThat(entity.getNombre()).isEqualTo("ZONA-ACTUALIZADA");
        assertThat(entity.getCapacidad()).isEqualTo(60);
        // Los campos de auditoría no deben cambiar
        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    private Zona createEntity(Long id, String zona) {
        Zona entity = new Zona();
        entity.setId(id);
        entity.setNombre(zona);
        entity.setCapacidad(50);
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        
        // Crear sucursal
        Zona.Sucursal sucursal = new Zona.Sucursal();
        sucursal.setId(1L);
        sucursal.setNombre("SUCURSAL PRINCIPAL");
        entity.setSucursal(sucursal);
        
        return entity;
    }
}
