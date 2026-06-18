package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "af_prima_devengo",
        schema = "activos",
        uniqueConstraints = @UniqueConstraint(
                name = "uq_af_prima_devengo_poliza_periodo",
                columnNames = {"af_poliza_seguro_id", "anio", "mes"}))
public class AfPrimaDevengo extends BaseEntity {

    @Column(name = "af_poliza_seguro_id", nullable = false)
    private Long afPolizaSeguroId;

    @Column(nullable = false)
    private Integer anio;

    @Column(nullable = false)
    private Integer mes;

    @Column(name = "importe_devengado", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeDevengado;

    @Column(name = "meses_vigencia_poliza")
    private Integer mesesVigenciaPoliza;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;
}
