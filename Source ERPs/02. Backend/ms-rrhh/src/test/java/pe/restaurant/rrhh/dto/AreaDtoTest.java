package pe.restaurant.rrhh.dto;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import pe.restaurant.rrhh.dto.request.AreaRequest;
import pe.restaurant.rrhh.dto.response.AreaResponse;
import pe.restaurant.rrhh.dto.response.AreaTreeResponse;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("DTOs de Área — Pruebas Unitarias Completas")
class AreaDtoTest {

    @Test
    @DisplayName("AreaRequest -> getters y setters funcionan correctamente")
    void areaRequest_gettersSetters_funcionanCorrectamente() {
        // Arrange & Act
        AreaRequest request = new AreaRequest();
        request.setNombre("Finanzas");
        request.setPadreId(1L);
        request.setResponsableId(10L);

        // Assert
        assertThat(request.getNombre()).isEqualTo("Finanzas");
        assertThat(request.getPadreId()).isEqualTo(1L);
        assertThat(request.getResponsableId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("AreaRequest -> valores nulos funcionan correctamente")
    void areaRequest_valoresNulos_funcionanCorrectamente() {
        // Arrange & Act
        AreaRequest request = new AreaRequest();
        request.setNombre(null);
        request.setPadreId(null);
        request.setResponsableId(null);

        // Assert
        assertThat(request.getNombre()).isNull();
        assertThat(request.getPadreId()).isNull();
        assertThat(request.getResponsableId()).isNull();
    }

    @Test
    @DisplayName("AreaRequest -> valores límite funcionan correctamente")
    void areaRequest_valoresLimite_funcionanCorrectamente() {
        // Arrange & Act
        AreaRequest request = new AreaRequest();
        request.setNombre(""); // String vacío
        request.setPadreId(0L); // Long cero
        request.setResponsableId(Long.MAX_VALUE); // Long máximo

        // Assert
        assertThat(request.getNombre()).isEqualTo("");
        assertThat(request.getPadreId()).isEqualTo(0L);
        assertThat(request.getResponsableId()).isEqualTo(Long.MAX_VALUE);
    }

    @Test
    @DisplayName("AreaRequest -> toString funciona correctamente")
    void areaRequest_toString_funcionaCorrectamente() {
        // Arrange & Act
        AreaRequest request = new AreaRequest();
        request.setNombre("Test Request");

        // Assert
        String toString = request.toString();
        assertThat(toString).contains("nombre=Test Request");
    }

    @Test
    @DisplayName("AreaRequest -> toString con valores nulos")
    void areaRequest_toString_conValoresNulos() {
        // Arrange & Act
        AreaRequest request = new AreaRequest();
        request.setNombre(null);

        // Assert
        String toString = request.toString();
        assertThat(toString).contains("AreaRequest");
    }

    @Test
    @DisplayName("AreaResponse -> getters y setters funcionan correctamente")
    void areaResponse_gettersSetters_funcionanCorrectamente() {
        // Arrange
        OffsetDateTime now = OffsetDateTime.now();
        
        // Act
        AreaResponse response = new AreaResponse();
        response.setId(1L);
        response.setNombre("Finanzas");
        response.setPadreId(null);
        response.setResponsableId(10L);
        response.setCreatedBy(100L);
        response.setFecCreacion(now);
        response.setUpdatedBy(100L);
        response.setFecModificacion(now);

        // Assert
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Finanzas");
        assertThat(response.getPadreId()).isNull();
        assertThat(response.getResponsableId()).isEqualTo(10L);
        assertThat(response.getCreatedBy()).isEqualTo(100L);
        assertThat(response.getFecCreacion()).isEqualTo(now);
        assertThat(response.getUpdatedBy()).isEqualTo(100L);
        assertThat(response.getFecModificacion()).isEqualTo(now);
    }

    @Test
    @DisplayName("AreaResponse -> valores nulos funcionan correctamente")
    void areaResponse_valoresNulos_funcionanCorrectamente() {
        // Arrange & Act
        AreaResponse response = new AreaResponse();
        response.setId(null);
        response.setNombre(null);
        response.setPadreId(null);
        response.setResponsableId(null);
        response.setCreatedBy(null);
        response.setFecCreacion(null);
        response.setUpdatedBy(null);
        response.setFecModificacion(null);

        // Assert
        assertThat(response.getId()).isNull();
        assertThat(response.getNombre()).isNull();
        assertThat(response.getPadreId()).isNull();
        assertThat(response.getResponsableId()).isNull();
        assertThat(response.getCreatedBy()).isNull();
        assertThat(response.getFecCreacion()).isNull();
        assertThat(response.getUpdatedBy()).isNull();
        assertThat(response.getFecModificacion()).isNull();
    }

    @Test
    @DisplayName("AreaResponse -> toString funciona correctamente")
    void areaResponse_toString_funcionaCorrectamente() {
        // Arrange & Act
        AreaResponse response = new AreaResponse();
        response.setId(1L);
        response.setNombre("Test");

        // Assert
        String toString = response.toString();
        assertThat(toString).contains("id=1");
        assertThat(toString).contains("nombre=Test");
    }

    @Test
    @DisplayName("AreaResponse -> toString con valores nulos")
    void areaResponse_toString_conValoresNulos() {
        // Arrange & Act
        AreaResponse response = new AreaResponse();
        response.setId(null);
        response.setNombre(null);

        // Assert
        String toString = response.toString();
        assertThat(toString).contains("AreaResponse");
    }

    @Test
    @DisplayName("AreaTreeResponse -> getters y setters funcionan correctamente")
    void areaTreeResponse_gettersSetters_funcionanCorrectamente() {
        // Arrange
        AreaTreeResponse hijo1 = new AreaTreeResponse();
        hijo1.setId(2L);
        hijo1.setNombre("Sub-Contabilidad");
        hijo1.setPadreId(1L);
        hijo1.setHijos(Collections.emptyList());

        AreaTreeResponse hijo2 = new AreaTreeResponse();
        hijo2.setId(3L);
        hijo2.setNombre("Auditoría");
        hijo2.setPadreId(1L);
        hijo2.setHijos(Collections.emptyList());

        // Act
        AreaTreeResponse response = new AreaTreeResponse();
        response.setId(1L);
        response.setNombre("Finanzas");
        response.setPadreId(null);
        response.setResponsableId(10L);
        response.setHijos(List.of(hijo1, hijo2));

        // Assert
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getNombre()).isEqualTo("Finanzas");
        assertThat(response.getPadreId()).isNull();
        assertThat(response.getResponsableId()).isEqualTo(10L);
        assertThat(response.getHijos()).hasSize(2);
        assertThat(response.getHijos().get(0).getNombre()).isEqualTo("Sub-Contabilidad");
        assertThat(response.getHijos().get(1).getNombre()).isEqualTo("Auditoría");
    }

    @Test
    @DisplayName("AreaTreeResponse -> lista vacía de hijos")
    void areaTreeResponse_listaVaciaDeHijos() {
        // Arrange & Act
        AreaTreeResponse response = new AreaTreeResponse();
        response.setId(1L);
        response.setNombre("Raíz");
        response.setHijos(Collections.emptyList());

        // Assert
        assertThat(response.getHijos()).isEmpty();
        assertThat(response.getHijos()).isInstanceOf(List.class);
    }

    @Test
    @DisplayName("AreaTreeResponse -> lista nula de hijos")
    void areaTreeResponse_listaNulaDeHijos() {
        // Arrange & Act
        AreaTreeResponse response = new AreaTreeResponse();
        response.setId(1L);
        response.setNombre("Raíz");
        response.setHijos(null);

        // Assert
        assertThat(response.getHijos()).isNull();
    }

    @Test
    @DisplayName("AreaTreeResponse -> estructura jerárquica anidada")
    void areaTreeResponse_estructuraJerarquicaAnidada() {
        // Arrange
        AreaTreeResponse nieto = new AreaTreeResponse();
        nieto.setId(3L);
        nieto.setNombre("Nieto");
        nieto.setPadreId(2L);
        nieto.setHijos(Collections.emptyList());

        AreaTreeResponse hijo = new AreaTreeResponse();
        hijo.setId(2L);
        hijo.setNombre("Hijo");
        hijo.setPadreId(1L);
        hijo.setHijos(List.of(nieto));

        AreaTreeResponse padre = new AreaTreeResponse();
        padre.setId(1L);
        padre.setNombre("Padre");
        padre.setPadreId(null);
        padre.setHijos(List.of(hijo));

        // Act & Assert
        assertThat(padre.getHijos()).hasSize(1);
        assertThat(padre.getHijos().get(0).getNombre()).isEqualTo("Hijo");
        assertThat(padre.getHijos().get(0).getHijos()).hasSize(1);
        assertThat(padre.getHijos().get(0).getHijos().get(0).getNombre()).isEqualTo("Nieto");
        assertThat(padre.getHijos().get(0).getHijos().get(0).getHijos()).isEmpty();
    }

    @Test
    @DisplayName("AreaTreeResponse -> toString funciona correctamente")
    void areaTreeResponse_toString_funcionaCorrectamente() {
        // Arrange & Act
        AreaTreeResponse response = new AreaTreeResponse();
        response.setId(1L);
        response.setNombre("Test Tree");
        response.setHijos(Collections.emptyList());

        // Assert
        String toString = response.toString();
        assertThat(toString).contains("id=1");
        assertThat(toString).contains("nombre=Test Tree");
    }

    @Test
    @DisplayName("AreaTreeResponse -> toString con hijos")
    void areaTreeResponse_toString_conHijos() {
        // Arrange
        AreaTreeResponse hijo = new AreaTreeResponse();
        hijo.setId(2L);
        hijo.setNombre("Hijo");
        hijo.setHijos(Collections.emptyList());

        // Act
        AreaTreeResponse response = new AreaTreeResponse();
        response.setId(1L);
        response.setNombre("Padre");
        response.setHijos(List.of(hijo));

        // Assert
        String toString = response.toString();
        assertThat(toString).contains("id=1");
        assertThat(toString).contains("nombre=Padre");
    }

    @Test
    @DisplayName("AreaTreeResponse -> toString con valores nulos")
    void areaTreeResponse_toString_conValoresNulos() {
        // Arrange & Act
        AreaTreeResponse response = new AreaTreeResponse();
        response.setId(null);
        response.setNombre(null);
        response.setHijos(null);

        // Assert
        String toString = response.toString();
        assertThat(toString).contains("AreaTreeResponse");
    }

    @Test
    @DisplayName("AreaTreeResponse -> estructura multinivel compleja")
    void areaTreeResponse_estructuraMultinivelCompleja() {
        // Arrange
        List<AreaTreeResponse> hijosNivel3 = new ArrayList<>();
        for (int i = 1; i <= 3; i++) {
            AreaTreeResponse nieto = new AreaTreeResponse();
            nieto.setId((long) (i + 10));
            nieto.setNombre("Nieto " + i);
            nieto.setPadreId(2L);
            nieto.setHijos(Collections.emptyList());
            hijosNivel3.add(nieto);
        }

        AreaTreeResponse hijo = new AreaTreeResponse();
        hijo.setId(2L);
        hijo.setNombre("Hijo Principal");
        hijo.setPadreId(1L);
        hijo.setHijos(hijosNivel3);

        AreaTreeResponse padre = new AreaTreeResponse();
        padre.setId(1L);
        padre.setNombre("Raíz Principal");
        padre.setPadreId(null);
        padre.setHijos(List.of(hijo));

        // Act & Assert
        assertThat(padre.getHijos()).hasSize(1);
        assertThat(padre.getHijos().get(0).getHijos()).hasSize(3);
        assertThat(padre.getHijos().get(0).getHijos().get(0).getNombre()).isEqualTo("Nieto 1");
        assertThat(padre.getHijos().get(0).getHijos().get(1).getNombre()).isEqualTo("Nieto 2");
        assertThat(padre.getHijos().get(0).getHijos().get(2).getNombre()).isEqualTo("Nieto 3");
    }

    @Test
    @DisplayName("AreaRequest -> equals y hashCode funcionan correctamente")
    void areaRequest_equalsHashCode_funcionanCorrectamente() {
        // Arrange
        AreaRequest request1 = new AreaRequest();
        request1.setNombre("Test");
        request1.setPadreId(1L);
        request1.setResponsableId(10L);

        AreaRequest request2 = new AreaRequest();
        request2.setNombre("Test");
        request2.setPadreId(1L);
        request2.setResponsableId(10L);

        AreaRequest request3 = new AreaRequest();
        request3.setNombre("Different");
        request3.setPadreId(2L);
        request3.setResponsableId(20L);

        // Act & Assert
        assertThat(request1).isEqualTo(request2);
        assertThat(request1.hashCode()).isEqualTo(request2.hashCode());
        assertThat(request1).isNotEqualTo(request3);
        assertThat(request1.hashCode()).isNotEqualTo(request3.hashCode());
    }

    @Test
    @DisplayName("AreaResponse -> equals y hashCode funcionan correctamente")
    void areaResponse_equalsHashCode_funcionanCorrectamente() {
        // Arrange
        OffsetDateTime now = OffsetDateTime.now();
        
        AreaResponse response1 = new AreaResponse();
        response1.setId(1L);
        response1.setNombre("Test");
        response1.setFecCreacion(now);

        AreaResponse response2 = new AreaResponse();
        response2.setId(1L);
        response2.setNombre("Test");
        response2.setFecCreacion(now);

        AreaResponse response3 = new AreaResponse();
        response3.setId(2L);
        response3.setNombre("Different");
        response3.setFecCreacion(now);

        // Act & Assert
        assertThat(response1).isEqualTo(response2);
        assertThat(response1.hashCode()).isEqualTo(response2.hashCode());
        assertThat(response1).isNotEqualTo(response3);
        assertThat(response1.hashCode()).isNotEqualTo(response3.hashCode());
    }

    @Test
    @DisplayName("AreaTreeResponse -> equals y hashCode funcionan correctamente")
    void areaTreeResponse_equalsHashCode_funcionanCorrectamente() {
        // Arrange
        AreaTreeResponse tree1 = new AreaTreeResponse();
        tree1.setId(1L);
        tree1.setNombre("Test");
        tree1.setHijos(Collections.emptyList());

        AreaTreeResponse tree2 = new AreaTreeResponse();
        tree2.setId(1L);
        tree2.setNombre("Test");
        tree2.setHijos(Collections.emptyList());

        AreaTreeResponse tree3 = new AreaTreeResponse();
        tree3.setId(2L);
        tree3.setNombre("Different");
        tree3.setHijos(Collections.emptyList());

        // Act & Assert
        assertThat(tree1).isEqualTo(tree2);
        assertThat(tree1.hashCode()).isEqualTo(tree2.hashCode());
        assertThat(tree1).isNotEqualTo(tree3);
        assertThat(tree1.hashCode()).isNotEqualTo(tree3.hashCode());
    }
}
