package pe.restaurant.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.AuditOnlyMappedEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "labor_ejecutor", schema = "produccion")
public class LaborEjecutor extends AuditOnlyMappedEntity {

    @Column(name = "labor_id", nullable = false)
    private Long laborId;

    @Column(name = "ejecutor_id", nullable = false)
    private Long ejecutorId;

    @Column(name = "unidad_medida_alt_id")
    private Long unidadMedidaAltId;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "factor_conversion", precision = 7, scale = 4)
    private BigDecimal factorConversion;

    @Column(name = "nro_personas")
    private Integer nroPersonas;

    @Column(name = "ratio_estimado", precision = 12, scale = 4)
    private BigDecimal ratioEstimado;

    @Column(name = "costo_unitario", precision = 18, scale = 4)
    private BigDecimal costoUnitario;

    @Column(name = "flag_costo_fijo", length = 1)
    private String flagCostoFijo;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
