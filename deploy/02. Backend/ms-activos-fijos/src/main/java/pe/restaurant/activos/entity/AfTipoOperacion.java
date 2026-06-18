package pe.restaurant.activos.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
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
        name = "af_tipo_operacion",
        schema = "activos",
        uniqueConstraints = @UniqueConstraint(name = "uq_af_tipo_operacion_codigo", columnNames = "codigo"))
public class AfTipoOperacion extends BaseEntity {

    @Column(nullable = false, length = 10)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String descripcion;

    @Column(nullable = false, length = 20)
    private String naturaleza;

    @Column(name = "tipo_calculo", nullable = false, length = 30)
    private String tipoCalculo;

    @Column(precision = 8, scale = 4)
    private BigDecimal tasa;

    @Column(name = "metodo_calculo", length = 30)
    private String metodoCalculo;

    @Column(name = "cuenta_contable_id")
    private Long cuentaContableId;

    @Column(name = "centro_costo_id")
    private Long centroCostoId;

    @Column(name = "afecta_contabilidad", nullable = false)
    private Boolean afectaContabilidad = true;

    @Column(name = "modulo_contable", length = 30)
    private String moduloContable;

    @Column(name = "tipo_operacion_contable", length = 60)
    private String tipoOperacionContable;

    @Column(length = 500)
    private String observaciones;
}
