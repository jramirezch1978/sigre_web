package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Detalle de boleta de pagos: una línea por concepto de planilla.
 */
@Entity
@Table(name = "calculo_det", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CalculoDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "calculo_id", nullable = false)
    private Long calculoId;

    @Column(name = "concepto_id", nullable = false)
    private Long conceptoId;

    @Column(name = "item", nullable = false)
    private Short item;

    @Column(name = "centro_costo_id")
    private Long centroCostoId;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "cnta_crrte_id")
    private Long cntaCrrteId;

    @Column(name = "cnta_crrte_det_id")
    private Long cntaCrrteDetId;

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "nro_doc_cc", length = 10)
    private String nroDocCc;

    @Column(name = "horas_trabajadas", precision = 8, scale = 2)
    private BigDecimal horasTrabajadas;

    @Column(name = "horas_pagadas", precision = 8, scale = 2)
    private BigDecimal horasPagadas;

    @Column(name = "dias_trabajados", precision = 6, scale = 2)
    private BigDecimal diasTrabajados;

    @Column(name = "imp_soles", nullable = false, precision = 18, scale = 5)
    private BigDecimal impSoles;

    @Column(name = "imp_dolar", nullable = false, precision = 18, scale = 5)
    private BigDecimal impDolar;

    @Column(name = "pesca_capturada", precision = 12, scale = 4)
    private BigDecimal pescaCapturada;

    @Column(name = "tipo_concepto_calculo_id", nullable = false)
    private Long tipoConceptoCalculoId;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
