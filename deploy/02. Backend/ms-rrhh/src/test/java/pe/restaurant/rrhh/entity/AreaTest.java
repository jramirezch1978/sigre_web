package pe.restaurant.rrhh.entity;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Instant;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("Area Entity — Pruebas Unitarias")
class AreaTest {

    @Test
    @DisplayName("Getters y setters funcionan correctamente")
    void gettersSetters_funcionanCorrectamente() {
        // Arrange
        Instant now = Instant.now();
        Area area = new Area();

        // Act
        area.setId(1L);
        area.setNombre("Finanzas");
        area.setPadreId(null);
        area.setResponsableId(10L);
        area.setCreatedBy(100L);
        area.setFecCreacion(now);
        area.setUpdatedBy(100L);
        area.setFecModificacion(now);

        // Assert
        assertThat(area.getId()).isEqualTo(1L);
        assertThat(area.getNombre()).isEqualTo("Finanzas");
        assertThat(area.getPadreId()).isNull();
        assertThat(area.getResponsableId()).isEqualTo(10L);
        assertThat(area.getCreatedBy()).isEqualTo(100L);
        assertThat(area.getFecCreacion()).isEqualTo(now);
        assertThat(area.getUpdatedBy()).isEqualTo(100L);
        assertThat(area.getFecModificacion()).isEqualTo(now);
    }

    @Test
    @DisplayName("Constructor sin argumentos funciona correctamente")
    void constructorSinArgumentos_funcionaCorrectamente() {
        // Act
        Area area = new Area();

        // Assert
        assertThat(area).isNotNull();
        assertThat(area.getId()).isNull();
        assertThat(area.getNombre()).isNull();
        assertThat(area.getPadreId()).isNull();
        assertThat(area.getResponsableId()).isNull();
        assertThat(area.getCreatedBy()).isNull();
        assertThat(area.getFecCreacion()).isNull();
        assertThat(area.getUpdatedBy()).isNull();
        assertThat(area.getFecModificacion()).isNull();
    }

    @Test
    @DisplayName("Constructor con todos los argumentos funciona correctamente")
    void constructorConTodosLosArgumentos_funcionaCorrectamente() {
        // Arrange
        Instant now = Instant.now();

        // Act
        Area area = new Area();
        area.setId(1L);
        area.setNombre("Finanzas");
        area.setPadreId(null);
        area.setResponsableId(null);
        area.setCreatedBy(100L);
        area.setFecCreacion(now);
        area.setUpdatedBy(100L);
        area.setFecModificacion(now);

        // Assert
        assertThat(area.getId()).isEqualTo(1L);
        assertThat(area.getNombre()).isEqualTo("Finanzas");
        assertThat(area.getPadreId()).isNull();
        assertThat(area.getResponsableId()).isNull();
        assertThat(area.getCreatedBy()).isEqualTo(100L);
        assertThat(area.getFecCreacion()).isEqualTo(now);
        assertThat(area.getUpdatedBy()).isEqualTo(100L);
        assertThat(area.getFecModificacion()).isEqualTo(now);
    }

    @Test
    @DisplayName("Relación padre-hijo funciona correctamente")
    void relacionPadreHijo_funcionaCorrectamente() {
        // Arrange
        Area padre = new Area();
        padre.setId(1L);
        padre.setNombre("Padre");
        padre.setPadreId(null);

        Area hijo = new Area();
        hijo.setId(2L);
        hijo.setNombre("Hijo");
        hijo.setPadreId(1L);
        hijo.setPadre(padre);

        // Act & Assert
        assertThat(hijo.getPadreId()).isEqualTo(1L);
        assertThat(hijo.getPadre()).isNotNull();
        assertThat(hijo.getPadre().getId()).isEqualTo(1L);
        assertThat(hijo.getPadre().getNombre()).isEqualTo("Padre");
        assertThat(padre.getPadreId()).isNull();
        assertThat(padre.getPadre()).isNull();
    }

    @Test
    @DisplayName("toString funciona correctamente")
    void toString_funcionaCorrectamente() {
        // Arrange
        Area area = new Area();
        area.setId(1L);
        area.setNombre("Test");

        // Act
        String toString = area.toString();

        // Assert
        assertThat(toString).contains("nombre=Test");
    }

    @Test
    @DisplayName("equals funciona correctamente")
    void equals_funcionaCorrectamente() {
        // Arrange
        Area area1 = new Area();
        area1.setId(1L);
        area1.setNombre("Finanzas");

        Area area2 = new Area();
        area2.setId(1L);
        area2.setNombre("Finanzas");

        Area area3 = new Area();
        area3.setId(2L);
        area3.setNombre("Contabilidad");

        // Act & Assert
        assertThat(area1).isEqualTo(area2); // Mismo contenido
        assertThat(area1).isNotEqualTo(area3); // Diferente contenido
        assertThat(area1).isNotEqualTo(null); // Null
        assertThat(area1).isNotEqualTo("string"); // Diferente tipo
    }

    @Test
    @DisplayName("hashCode funciona correctamente")
    void hashCode_funcionaCorrectamente() {
        // Arrange
        Area area1 = new Area();
        area1.setId(1L);
        area1.setNombre("Finanzas");

        Area area2 = new Area();
        area2.setId(1L);
        area2.setNombre("Finanzas");

        Area area3 = new Area();
        area3.setId(2L);
        area3.setNombre("Recursos Humanos");

        // Act & Assert
        assertThat(area1.hashCode()).isEqualTo(area2.hashCode()); // Mismo estado
        assertThat(area1.hashCode()).isNotEqualTo(area3.hashCode()); // Diferente estado
    }

    @Test
    @DisplayName("Campos de auditoría funcionan correctamente")
    void camposAuditoria_funcionanCorrectamente() {
        // Arrange
        Instant creacion = Instant.now();
        Instant modificacion = creacion.plusSeconds(60);

        // Act
        Area area = new Area();
        area.setCreatedBy(100L);
        area.setFecCreacion(creacion);
        area.setUpdatedBy(200L);
        area.setFecModificacion(modificacion);

        // Assert
        assertThat(area.getCreatedBy()).isEqualTo(100L);
        assertThat(area.getFecCreacion()).isEqualTo(creacion);
        assertThat(area.getUpdatedBy()).isEqualTo(200L);
        assertThat(area.getFecModificacion()).isEqualTo(modificacion);
        assertThat(area.getFecModificacion()).isAfter(area.getFecCreacion());
    }

    @Test
    @DisplayName("Jerarquía multinivel funciona correctamente")
    void jerarquiaMultinivel_funcionaCorrectamente() {
        // Arrange
        Area abuelo = new Area();
        abuelo.setId(1L);
        abuelo.setNombre("Abuelo");
        abuelo.setPadreId(null);

        Area padre = new Area();
        padre.setId(2L);
        padre.setNombre("Padre");
        padre.setPadreId(1L);
        padre.setPadre(abuelo);

        Area hijo = new Area();
        hijo.setId(3L);
        hijo.setNombre("Hijo");
        hijo.setPadreId(2L);
        hijo.setPadre(padre);

        // Act & Assert
        assertThat(abuelo.getPadreId()).isNull();
        assertThat(abuelo.getPadre()).isNull();

        assertThat(padre.getPadreId()).isEqualTo(1L);
        assertThat(padre.getPadre()).isNotNull();
        assertThat(padre.getPadre().getId()).isEqualTo(1L);

        assertThat(hijo.getPadreId()).isEqualTo(2L);
        assertThat(hijo.getPadre()).isNotNull();
        assertThat(hijo.getPadre().getId()).isEqualTo(2L);
        assertThat(hijo.getPadre().getPadre()).isNotNull();
        assertThat(hijo.getPadre().getPadre().getId()).isEqualTo(1L);
    }
}
