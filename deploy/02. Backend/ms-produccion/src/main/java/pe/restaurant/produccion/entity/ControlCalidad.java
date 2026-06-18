package pe.restaurant.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.AuditOnlyMappedEntity;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "control_calidad", schema = "produccion")
public class ControlCalidad extends AuditOnlyMappedEntity {

    @Column(name = "orden_trabajo_id")
    private Long ordenTrabajoId;

    @Column(name = "inspector_id")
    private Long inspectorId;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "resultado", nullable = false, length = 20)
    private String resultado;

    @Column(name = "observaciones")
    private String observaciones;
}
