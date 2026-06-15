package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cntas_cobrar_det_imp", schema = "ventas")
public class CntasCobrarDetImp {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cntas_cobrar_det_id", nullable = false)
    private CuentaCobrarDet cntasCobrarDet;

    @Column(name = "tipos_impuesto_id", nullable = false)
    private Long tiposImpuestoId;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal importe = BigDecimal.ZERO;

    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
