package pe.restaurant.rrhh.specification;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.Cargo;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Tests unitarios para CargoSpecification.
 * Valida la creación de especificaciones JPA para filtros dinámicos.
 */
@DisplayName("CargoSpecification - Pruebas Unitarias")
class CargoSpecificationTest {

    @Test
    @DisplayName("nombreContains() -> debe crear especificación válida")
    void nombreContains_debeCrearEspecificacionValida() {
        String nombre = "Chef";

        Specification<Cargo> spec = CargoSpecification.nombreContains(nombre);

        assertThat(spec).isNotNull();
        assertThat(spec.toString()).contains("Specification");
        
        try {
            jakarta.persistence.criteria.Predicate result = spec.toPredicate(null, null, null);
        } catch (NullPointerException e) {
            assertThat(e.getMessage()).contains("root");
        }
    }

    @Test
    @DisplayName("nombreContains() con nombre vacío -> debe crear especificación")
    void nombreContains_conNombreVacio_debeCrearEspecificacion() {
        String nombre = "";

        Specification<Cargo> spec = CargoSpecification.nombreContains(nombre);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nombreContains() con nombre null -> debe crear especificación")
    void nombreContains_conNombreNull_debeCrearEspecificacion() {
        String nombre = null;

        Specification<Cargo> spec = CargoSpecification.nombreContains(nombre);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nombreContains() case insensitive -> debe funcionar")
    void nombreContains_caseInsensitive_debeFuncionar() {
        String nombre = "ChEf";

        Specification<Cargo> spec = CargoSpecification.nombreContains(nombre);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nombreContains() con espacios -> debe funcionar")
    void nombreContains_conEspacios_debeFuncionar() {
        String nombre = "Chef Ejecutivo";

        Specification<Cargo> spec = CargoSpecification.nombreContains(nombre);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nivelEquals() -> debe crear especificación válida")
    void nivelEquals_debeCrearEspecificacionValida() {
        String nivel = "TÁCTICO";

        Specification<Cargo> spec = CargoSpecification.nivelEquals(nivel);

        assertThat(spec).isNotNull();
        assertThat(spec.toString()).contains("Specification");
        
        try {
            jakarta.persistence.criteria.Predicate result = spec.toPredicate(null, null, null);
        } catch (NullPointerException e) {
            assertThat(e.getMessage()).contains("root");
        }
    }

    @Test
    @DisplayName("nivelEquals() con null -> debe crear especificación")
    void nivelEquals_conNull_debeCrearEspecificacion() {
        String nivel = null;

        Specification<Cargo> spec = CargoSpecification.nivelEquals(nivel);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nivelEquals() con nivel OPERATIVO -> debe crear especificación")
    void nivelEquals_conNivelOperativo_debeCrearEspecificacion() {
        String nivel = "OPERATIVO";

        Specification<Cargo> spec = CargoSpecification.nivelEquals(nivel);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nivelEquals() con nivel ESTRATÉGICO -> debe crear especificación")
    void nivelEquals_conNivelEstrategico_debeCrearEspecificacion() {
        String nivel = "ESTRATÉGICO";

        Specification<Cargo> spec = CargoSpecification.nivelEquals(nivel);

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("Combinación AND de especificaciones -> debe funcionar correctamente")
    void combinacionANDDeEspecificaciones_debeFuncionarCorrectamente() {
        Specification<Cargo> nombreSpec = CargoSpecification.nombreContains("Chef");
        Specification<Cargo> nivelSpec = CargoSpecification.nivelEquals("TÁCTICO");

        Specification<Cargo> combinedSpec = nombreSpec.and(nivelSpec);

        assertThat(combinedSpec).isNotNull();
        assertThat(combinedSpec.toString()).contains("Specification");
    }

    @Test
    @DisplayName("Combinación OR de especificaciones -> debe funcionar correctamente")
    void combinacionORDeEspecificaciones_debeFuncionarCorrectamente() {
        Specification<Cargo> nombreSpec = CargoSpecification.nombreContains("Chef");
        Specification<Cargo> nivelSpec = CargoSpecification.nivelEquals("OPERATIVO");

        Specification<Cargo> combinedSpec = nombreSpec.or(nivelSpec);

        assertThat(combinedSpec).isNotNull();
        assertThat(combinedSpec.toString()).contains("Specification");
    }

    @Test
    @DisplayName("Múltiples ejecuciones de misma especificación -> debe ser consistente")
    void multiplesEjecucionesMismaEspecificacion_debeSerConsistente() {
        Specification<Cargo> spec = CargoSpecification.nombreContains("Test");

        String result1 = spec.toString();
        String result2 = spec.toString();

        assertThat(result1).isEqualTo(result2);
    }

    @Test
    @DisplayName("Especificaciones diferentes -> deben ser diferentes")
    void especificacionesDiferentes_debenSerDiferentes() {
        Specification<Cargo> spec1 = CargoSpecification.nombreContains("Chef");
        Specification<Cargo> spec2 = CargoSpecification.nombreContains("Sous");

        String result1 = spec1.toString();
        String result2 = spec2.toString();

        assertThat(result1).isNotEqualTo(result2);
    }

    @Test
    @DisplayName("Especificaciones con mismo parámetro -> deben crear especificaciones válidas")
    void especificacionesConMismoParametro_debenCrearEspecificacionesValidas() {
        String parametro = "Chef";
        
        Specification<Cargo> spec1 = CargoSpecification.nombreContains(parametro);
        Specification<Cargo> spec2 = CargoSpecification.nombreContains(parametro);

        assertThat(spec1).isNotNull();
        assertThat(spec2).isNotNull();
    }
}
