package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;
import java.math.BigDecimal;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "capacitacion_trabajador", schema = "rrhh")
public class CapacitacionTrabajador extends BaseEntity {

    @Column(name = "capacitacion_id", nullable = false)
    private Long capacitacionId;

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "asistio", nullable = false)
    private Boolean asistio = false;

    @Column(name = "calificacion", precision = 8, scale = 2)
    private BigDecimal calificacion;

    @Column(name = "certificado", nullable = false)
    private Boolean certificado = false;
}
