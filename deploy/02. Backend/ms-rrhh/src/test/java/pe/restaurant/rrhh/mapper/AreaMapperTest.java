package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.AreaRequest;
import pe.restaurant.rrhh.dto.response.AreaResponse;
import pe.restaurant.rrhh.dto.response.AreaTreeResponse;
import pe.restaurant.rrhh.entity.Area;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("AreaMapper — Pruebas Unitarias")
class AreaMapperTest {

    private final AreaMapper mapper = Mappers.getMapper(AreaMapper.class);
    
    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        // Arrange
        Area entity = RrhhTestFixtures.area(1L, "Gerencia", null);
        
        // Act
        AreaResponse response = mapper.toResponse(entity);
        
        // Assert
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Gerencia");
        assertThat(response.getPadreId()).isNull();
        assertThat(response.getCreatedBy()).isEqualTo(1L);
    }
    
    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        // Arrange
        List<Area> entities = List.of(
            RrhhTestFixtures.area(1L, "Gerencia", null),
            RrhhTestFixtures.area(2L, "Finanzas", 1L)
        );
        
        // Act
        List<AreaResponse> responses = mapper.toResponseList(entities);
        
        // Assert
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getNombre()).isEqualTo("Gerencia");
        assertThat(responses.get(1).getNombre()).isEqualTo("Finanzas");
        assertThat(responses.get(1).getPadreId()).isEqualTo(1L);
    }
    
    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad")
    void toEntity_convierteDTORequestAEntidad() {
        // Arrange
        AreaRequest request = RrhhTestFixtures.areaRequest("Nueva Área", 1L);
        
        // Act
        Area entity = mapper.toEntity(request);
        
        // Assert
        assertThat(entity.getId()).isNull();
        assertThat(entity.getNombre()).isEqualTo("Nueva Área");
        assertThat(entity.getPadreId()).isEqualTo(1L);
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }
    
    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente")
    void updateEntity_actualizaEntidadExistente() {
        // Arrange
        AreaRequest request = RrhhTestFixtures.areaRequest("Área Actualizada", 2L);
        Area entity = RrhhTestFixtures.area(1L, "Área Original", 1L);
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());
        
        // Act
        mapper.updateEntity(request, entity);
        
        // Assert
        assertThat(entity.getId()).isEqualTo(1L); // No debe cambiar
        assertThat(entity.getNombre()).isEqualTo("Área Actualizada");
        assertThat(entity.getPadreId()).isEqualTo(2L);
        assertThat(entity.getCreatedBy()).isEqualTo(1L); // No debe cambiar
        assertThat(entity.getFecCreacion()).isNotNull(); // No debe cambiar
    }
    
    @Test
    @DisplayName("toTreeResponse() -> convierte entidad a DTO de árbol")
    void toTreeResponse_convierteEntidadADTOArbol() {
        // Arrange
        Area entity = RrhhTestFixtures.area(1L, "Gerencia", null);
        
        // Act
        AreaTreeResponse response = mapper.toTreeResponse(entity);
        
        // Assert
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Gerencia");
        assertThat(response.getPadreId()).isNull();
        assertThat(response.getHijos()).isEmpty(); // Se construye manualmente en el servicio
    }
    
    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierteInstantAOffsetDateTime() {
        // Arrange
        java.time.Instant instant = java.time.Instant.parse("2023-01-01T12:00:00Z");
        
        // Act
        java.time.OffsetDateTime result = ((AreaMapperImpl) mapper).instantToOffsetDateTime(instant);
        
        // Assert
        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(java.time.ZoneOffset.UTC);
    }
    
    @Test
    @DisplayName("instantToOffsetDateTime() con null -> retorna null")
    void instantToOffsetDateTime_conNull_retornaNull() {
        // Act
        java.time.OffsetDateTime result = ((AreaMapperImpl) mapper).instantToOffsetDateTime(null);
        
        // Assert
        assertThat(result).isNull();
    }
    
    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        // Act
        AreaResponse response = mapper.toResponse(null);
        
        // Assert
        assertThat(response).isNull();
    }
    
    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        // Act
        List<AreaResponse> responses = mapper.toResponseList(null);
        
        // Assert
        assertThat(responses).isNull();
    }
    
    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        // Act
        Area entity = mapper.toEntity(null);
        
        // Assert
        assertThat(entity).isNull();
    }
    
    @Test
    @DisplayName("toTreeResponse() con entidad null -> retorna null")
    void toTreeResponse_conEntidadNull_retornaNull() {
        // Act
        AreaTreeResponse response = mapper.toTreeResponse(null);
        
        // Assert
        assertThat(response).isNull();
    }
}
