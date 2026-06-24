package com.sigre.rrhh.entity;

import com.sigre.common.entity.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Table(name = "retencion_judicial", schema = "rrhh")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class RetencionJudicial extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_planilla_id", nullable = false)
    private Long conceptoPlanillaId;

    @Column(name = "secuencia", nullable = false)
    private Short secuencia;

    @Column(name = "porcentaje", precision = 4, scale = 2)
    private BigDecimal porcentaje;

    @Column(name = "nom_pension", length = 200)
    private String nomPension;

    @Column(name = "importe", precision = 13, scale = 2)
    private BigDecimal importe;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";

    @Column(name = "nro_cnta_ahorro", length = 16)
    private String nroCntaAhorro;

    @Column(name = "porc_utilidad", nullable = false, precision = 4, scale = 2)
    private BigDecimal porcUtilidad = BigDecimal.ZERO;

    @Column(name = "banco_id")
    private Long bancoId;

    @Column(name = "porc_cts", nullable = false, precision = 4, scale = 2)
    private BigDecimal porcCts = BigDecimal.ZERO;

    @Column(name = "porc_grati", nullable = false, precision = 4, scale = 2)
    private BigDecimal porcGrati = BigDecimal.ZERO;

    @Column(name = "porc_vac", nullable = false, precision = 4, scale = 2)
    private BigDecimal porcVac = BigDecimal.ZERO;

    @Column(name = "imp_fijo_grati", nullable = false, precision = 13, scale = 2)
    private BigDecimal impFijoGrati = BigDecimal.ZERO;

    @Column(name = "imp_fijo_bonif", nullable = false, precision = 13, scale = 2)
    private BigDecimal impFijoBonif = BigDecimal.ZERO;

    @Column(name = "imp_fijo_vaca", nullable = false, precision = 13, scale = 2)
    private BigDecimal impFijoVaca = BigDecimal.ZERO;

    @Column(name = "imp_fijo_cts", nullable = false, precision = 13, scale = 2)
    private BigDecimal impFijoCts = BigDecimal.ZERO;
}
