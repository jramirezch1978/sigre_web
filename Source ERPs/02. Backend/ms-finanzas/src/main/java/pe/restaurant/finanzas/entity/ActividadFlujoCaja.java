package pe.restaurant.finanzas.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "actividad_flujo_caja", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(columnNames = {"codigo"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class ActividadFlujoCaja extends BaseEntity {

    @Column(name = "codigo", nullable = false, length = 2, unique = true)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 200)
    private String nombre;

    @Column(name = "orden", nullable = false)
    private Integer orden = 0;

    @Column(name = "flag_tipo_flujo", nullable = false, length = 1)
    private String flagTipoFlujo = "E";
}
