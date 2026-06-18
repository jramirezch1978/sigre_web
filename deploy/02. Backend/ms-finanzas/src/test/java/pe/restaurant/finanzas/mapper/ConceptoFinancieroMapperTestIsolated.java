package pe.restaurant.finanzas.mapper;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;
import pe.restaurant.finanzas.dto.request.ConceptoFinancieroRequest;
import pe.restaurant.finanzas.entity.ConceptoFinanciero;


@DisplayName("Pruebas Unitarias - ConceptoFinancieroMapper Aislado")
class ConceptoFinancieroMapperTestIsolated {


    // ==== testToEntityIsolated — otros ====

    @Test
    void testToEntityIsolated() {
        // Arrange - Crear un mapper completamente nuevo
        ConceptoFinancieroMapper mapper = Mappers.getMapper(ConceptoFinancieroMapper.class);
        
        ConceptoFinancieroRequest request = new ConceptoFinancieroRequest();
        request.setCodigo("CF002");
        request.setNombre("TEST");

        // Act
        ConceptoFinanciero entity = mapper.toEntity(request);

        // Assert
        System.out.println("=== AISLADO ===");
        System.out.println("Entity ID: " + entity.getId());
        System.out.println("Entity Codigo: " + entity.getCodigo());
        
        assertThat(entity).isNotNull();
        assertThat(entity.getCodigo()).isEqualTo("CF002");
        assertThat(entity.getNombre()).isEqualTo("TEST");
        assertThat(entity.getId()).isNull(); // Este debería ser null
    }
}
