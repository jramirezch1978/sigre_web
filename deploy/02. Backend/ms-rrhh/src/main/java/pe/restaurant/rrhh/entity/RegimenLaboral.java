package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "regimen_laboral", schema = "rrhh")
public class RegimenLaboral extends BaseEntity {
    @Column(name = "codigo", length = 20, nullable = false, unique = true)
    private String codigo;
    @Column(name = "nombre", length = 120, nullable = false)
    private String nombre;
    @Column(name = "factor_gratificacion", precision = 8, scale = 4)
    private java.math.BigDecimal factorGratificacion;
    @Column(name = "factor_vacacion", precision = 8, scale = 4)
    private java.math.BigDecimal factorVacacion;
    @Column(name = "factor_cts", precision = 8, scale = 4)
    private java.math.BigDecimal factorCts;
}
