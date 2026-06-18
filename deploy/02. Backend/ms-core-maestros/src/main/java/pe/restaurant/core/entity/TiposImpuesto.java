package pe.restaurant.core.entity;

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
@Table(name = "tipos_impuesto", schema = "core")
public class TiposImpuesto extends BaseEntity {

    @Column(name = "tipo_impuesto", nullable = false, unique = true, length = 10)
    private String tipoImpuesto;

    @Column(name = "plan_contable_det_id")
    private Long planContableDetId;

    @Column(name = "desc_impuesto", nullable = false, length = 200)
    private String descImpuesto;

    @Column(name = "tasa_impuesto", nullable = false, precision = 8, scale = 4)
    private BigDecimal tasaImpuesto = BigDecimal.ZERO;

    @Column(nullable = false, length = 1)
    private String signo = "+";

    @Column(name = "flag_dh_cxp", nullable = false, length = 1)
    private String flagDhCxp = "D";

    @Column(name = "flag_igv", nullable = false, length = 1)
    private String flagIgv = "0";

    /** 1=PORCENTAJE, 2=MONTO_FIJO, 3=BASE_AFFECTING (Chile/ILA). */
    @Column(name = "tipo_calculo", nullable = false)
    private Integer tipoCalculo = 1;
}
