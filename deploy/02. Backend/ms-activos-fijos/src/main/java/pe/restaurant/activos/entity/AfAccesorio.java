package pe.restaurant.activos.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "af_accesorios", schema = "activos")
public class AfAccesorio extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(nullable = false, length = 200)
    private String descripcion;

    @Column(precision = 18, scale = 4)
    private BigDecimal costo;

    @Column(name = "fecha_instalacion")
    private LocalDate fechaInstalacion;
}
