package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "liquidacion_det", schema = "finanzas",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = {"liquidacion_id", "item"})
    }
)
public class LiquidacionDet extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "liquidacion_id", nullable = false)
    private Liquidacion liquidacion;

    @Column(nullable = false)
    private Integer item;

    @Column(name = "origen_doc_ref", length = 2)
    private String origenDocRef;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "concepto_financiero_id", nullable = false)
    private Long conceptoFinancieroId;

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "cntas_cobrar_id")
    private Long cntasCobrarId;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "factor_signo")
    private Short factorSigno;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal importe = BigDecimal.ZERO;

    @Column(name = "flag_retencion", length = 1)
    private String flagRetencion = "0";

    @Column(name = "importe_retenido", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeRetenido = BigDecimal.ZERO;

    @Column(name = "flag_provisionado", length = 1)
    private String flagProvisionado = "0";
}
