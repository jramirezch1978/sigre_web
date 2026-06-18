package pe.restaurant.rrhh.mapper;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.CargoRequest;
import pe.restaurant.rrhh.dto.response.CargoResponse;
import pe.restaurant.rrhh.entity.Cargo;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para CargoMapper.
 * Valida las transformaciones entre Entity y DTOs.
 */
@DisplayName("CargoMapper — Pruebas Unitarias")
class CargoMapperTest {

    private final CargoMapper mapper = Mappers.getMapper(CargoMapper.class);
    
    @Test
    @DisplayName("toResponse() -> convierte entidad a DTO de respuesta")
    void toResponse_convierteEntidadADTORespuesta() {
        Cargo entity = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        
        CargoResponse response = mapper.toResponse(entity);
        
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Chef Ejecutivo");
        assertThat(response.getNivel()).isEqualTo("OPERATIVO");
        assertThat(response.getSueldoMinimo()).isEqualByComparingTo(new BigDecimal("2500.0000"));
        assertThat(response.getSueldoMaximo()).isEqualByComparingTo(new BigDecimal("4000.0000"));
        assertThat(response.getCreatedBy()).isEqualTo(1L);
    }
    
    @Test
    @DisplayName("toResponseList() -> convierte lista de entidades a lista de DTOs")
    void toResponseList_convierteListaDeEntidadesAListaDeDTOs() {
        List<Cargo> entities = List.of(
            RrhhTestFixtures.cargo(1L, "Chef Ejecutivo"),
            RrhhTestFixtures.cargo(2L, "Sous Chef")
        );
        
        List<CargoResponse> responses = mapper.toResponseList(entities);
        
        assertThat(responses).hasSize(2);
        assertThat(responses.get(0).getNombre()).isEqualTo("Chef Ejecutivo");
        assertThat(responses.get(1).getNombre()).isEqualTo("Sous Chef");
    }
    
    @Test
    @DisplayName("toEntity() -> convierte DTO request a entidad")
    void toEntity_convierteDTORequestAEntidad() {
        CargoRequest request = RrhhTestFixtures.cargoRequest("Chef Ejecutivo");
        
        Cargo entity = mapper.toEntity(request);
        
        assertThat(entity.getId()).isNull();
        assertThat(entity.getNombre()).isEqualTo("Chef Ejecutivo");
        assertThat(entity.getNivel()).isEqualTo("OPERATIVO");
        assertThat(entity.getSueldoMinimo()).isEqualByComparingTo(new BigDecimal("2500.0000"));
        assertThat(entity.getSueldoMaximo()).isEqualByComparingTo(new BigDecimal("4000.0000"));
        assertThat(entity.getCreatedBy()).isNull();
        assertThat(entity.getFecCreacion()).isNull();
    }
    
    @Test
    @DisplayName("updateEntity() -> actualiza entidad existente")
    void updateEntity_actualizaEntidadExistente() {
        CargoRequest request = RrhhTestFixtures.cargoRequest(
            "Chef Ejecutivo Senior",
            "TÁCTICO",
            new BigDecimal("4000.0000"),
            new BigDecimal("7000.0000")
        );
        Cargo entity = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        entity.setCreatedBy(1L);
        entity.setFecCreacion(java.time.Instant.now());
        
        mapper.updateEntity(request, entity);
        
        assertThat(entity.getId()).isEqualTo(1L);
        assertThat(entity.getNombre()).isEqualTo("Chef Ejecutivo Senior");
        assertThat(entity.getNivel()).isEqualTo("TÁCTICO");
        assertThat(entity.getSueldoMinimo()).isEqualByComparingTo(new BigDecimal("4000.0000"));
        assertThat(entity.getSueldoMaximo()).isEqualByComparingTo(new BigDecimal("7000.0000"));
        assertThat(entity.getCreatedBy()).isEqualTo(1L);
        assertThat(entity.getFecCreacion()).isNotNull();
    }
    
    @Test
    @DisplayName("instantToOffsetDateTime() -> convierte Instant a OffsetDateTime")
    void instantToOffsetDateTime_convierteInstantAOffsetDateTime() {
        java.time.Instant instant = java.time.Instant.parse("2023-01-01T12:00:00Z");
        
        java.time.OffsetDateTime result = ((CargoMapperImpl) mapper).instantToOffsetDateTime(instant);
        
        assertThat(result).isNotNull();
        assertThat(result.toInstant()).isEqualTo(instant);
        assertThat(result.getOffset()).isEqualTo(java.time.ZoneOffset.UTC);
    }
    
    @Test
    @DisplayName("instantToOffsetDateTime() con null -> retorna null")
    void instantToOffsetDateTime_conNull_retornaNull() {
        java.time.OffsetDateTime result = ((CargoMapperImpl) mapper).instantToOffsetDateTime(null);
        
        assertThat(result).isNull();
    }
    
    @Test
    @DisplayName("toResponse() con entidad null -> retorna null")
    void toResponse_conEntidadNull_retornaNull() {
        CargoResponse response = mapper.toResponse(null);
        
        assertThat(response).isNull();
    }
    
    @Test
    @DisplayName("toResponseList() con lista null -> retorna null")
    void toResponseList_conListaNull_retornaNull() {
        List<CargoResponse> responses = mapper.toResponseList(null);
        
        assertThat(responses).isNull();
    }
    
    @Test
    @DisplayName("toEntity() con request null -> retorna null")
    void toEntity_conRequestNull_retornaNull() {
        Cargo entity = mapper.toEntity(null);
        
        assertThat(entity).isNull();
    }
}
