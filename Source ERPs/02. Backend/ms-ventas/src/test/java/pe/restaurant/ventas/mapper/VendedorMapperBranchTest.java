package pe.restaurant.ventas.mapper;

import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.dto.request.VendedorRequest;
import pe.restaurant.ventas.dto.response.VendedorResponse;
import pe.restaurant.ventas.entity.Vendedor;

import java.time.Instant;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests de Branch Coverage para VendedorMapper
 * Cubre todos los branches condicionales de los métodos default
 */
class VendedorMapperBranchTest {

    private final VendedorMapper mapper = Mappers.getMapper(VendedorMapper.class);

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
        VendedorRequest request = new VendedorRequest();
        request.setUsuarioId(1L);
        request.setNombre("JUAN PEREZ");
        request.setComisionPorcentaje(new java.math.BigDecimal("5.00"));

        // When
        Vendedor entity = mapper.toEntity(request);

        // Then
        assertThat(entity).isNotNull();
        assertThat(entity.getUsuarioId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("JUAN PEREZ");
        assertThat(entity.getComisionPorcentaje()).isEqualTo(new java.math.BigDecimal("5.00"));
    }

    @Test
    void toResponse_conEntity_retornaResponse() {
        // Given
        Vendedor entity = new Vendedor();
        entity.setId(1L);
        entity.setUsuarioId(1L);
        entity.setNombre("JUAN PEREZ");
        entity.setComisionPorcentaje(new java.math.BigDecimal("5.00"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));

        // When
        VendedorResponse response = mapper.toResponse(entity);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getUsuarioId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("JUAN PEREZ");
        assertThat(response.getComisionPorcentaje()).isEqualTo(new java.math.BigDecimal("5.00"));
        assertThat(response.getFlagEstado()).isEqualTo("1");
        assertThat(response.getCreatedBy()).isEqualTo(1L);
        assertThat(response.getUpdatedBy()).isEqualTo(1L);
        assertThat(response.getFecCreacion()).isNotNull();
        assertThat(response.getFecModificacion()).isNotNull();
    }

    @Test
    void toResponseList_conLista_retornaListaDeResponses() {
        // Given
        List<Vendedor> entities = List.of(
                createEntity(1L, "JUAN PEREZ"),
                createEntity(2L, "MARIA LOPEZ")
        );

        // When
        List<VendedorResponse> responses = mapper.toResponseList(entities);

        // Then
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getId()).isEqualTo(1L);
        assertThat(responses.get(0).getNombre()).isEqualTo("JUAN PEREZ");
        assertThat(responses.get(1).getId()).isEqualTo(2L);
        assertThat(responses.get(1).getNombre()).isEqualTo("MARIA LOPEZ");
    }

    @Test
    void updateEntity_conRequest_actualizaEntity() {
        // Given
        Vendedor entity = createEntity(1L, "JUAN PEREZ");
        VendedorRequest request = new VendedorRequest();
        request.setNombre("CARLOS SANCHEZ");
        request.setComisionPorcentaje(new java.math.BigDecimal("6.00"));

        // When
        mapper.updateEntity(request, entity);

        // Then
        assertThat(entity.getNombre()).isEqualTo("CARLOS SANCHEZ");
        assertThat(entity.getComisionPorcentaje()).isEqualTo(new java.math.BigDecimal("6.00"));
        // Los campos de auditoría no deben cambiar
        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }

    private Vendedor createEntity(Long id, String nombre) {
        Vendedor entity = new Vendedor();
        entity.setId(id);
        entity.setUsuarioId(1L);
        entity.setNombre(nombre);
        entity.setComisionPorcentaje(new java.math.BigDecimal("5.00"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);
        entity.setUpdatedBy(1L);
        entity.setFecCreacion(Instant.ofEpochSecond(1640995200L));
        entity.setFecModificacion(Instant.ofEpochSecond(1640995200L));
        return entity;
    }
}
