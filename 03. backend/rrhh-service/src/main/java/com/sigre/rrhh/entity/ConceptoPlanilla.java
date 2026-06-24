package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

/**
 * Entidad alineada con catálogo SIGRE CONCEPTO (CONCEPTO.json).
 */
@Getter
@Setter
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "concepto_planilla", schema = "rrhh",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_CONCEPTO_PLANILLA_CODIGO", columnNames = "codigo")
    }
)
public class ConceptoPlanilla extends BaseEntity {

    @Column(name = "codigo", nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "descripcion_breve", length = 150)
    private String descripcionBreve;

    @Column(name = "factor_pago", nullable = false, precision = 18, scale = 6)
    private BigDecimal factorPago = BigDecimal.ONE;

    @Column(name = "importe_tope_min", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeTopeMin = BigDecimal.ZERO;

    @Column(name = "importe_tope_max", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeTopeMax = BigDecimal.ZERO;

    @Column(name = "numero_horas", precision = 6, scale = 2)
    private BigDecimal numeroHoras;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "grupo_conceptos_planilla_id", nullable = false)
    private GrupoConceptosPlanilla grupoConceptosPlanilla;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";

    @Column(name = "concepto_rtps", length = 10)
    private String conceptoRtps;

    @Column(name = "flag_subsidio", nullable = false, length = 1)
    private String flagSubsidio = "0";

    @Column(name = "flag_reporte_quinta", nullable = false, length = 1)
    private String flagReporteQuinta = "0";

    @Column(name = "numero_orden", length = 20)
    private String numeroOrden;
}
