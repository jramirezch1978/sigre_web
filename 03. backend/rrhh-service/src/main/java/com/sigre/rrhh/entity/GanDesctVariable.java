package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Ganancias y descuentos variables del trabajador (movimientos del período).
 * SIGRE: GAN_DESCT_FIJO con flag_destajo/variable — usado por sub-SPs de
 * ganancias variables, adelantos de quincena, promedio vacacional, etc.
 */
@Entity
@Table(name = "gan_desct_variable", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDesctVariable extends BaseEntity {

    /** FK → rrhh.trabajador. */
    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    /** Fecha del movimiento (mes de proceso). */
    @Column(name = "fec_movim", nullable = false)
    private LocalDate fecMovim;

    /** FK → rrhh.concepto_planilla (código 1xxx = ingreso, 2xxx = descuento). */
    @Column(name = "concepto_id", nullable = false)
    private Long conceptoId;

    @Column(name = "nro_doc", length = 30)
    private String nroDoc;

    /** Importe variable en soles. */
    @Column(name = "imp_var", precision = 18, scale = 4)
    private BigDecimal impVar;

    /** FK → contabilidad.centros_costo (opcional). */
    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "cant_labor", precision = 18, scale = 4)
    private BigDecimal cantLabor;

    /** Número de días (usado en cálculo por días). */
    @Column(name = "nro_dias", precision = 8, scale = 2)
    private BigDecimal nroDias;

    /** Número de horas (usado en cálculo por horas). */
    @Column(name = "nro_horas", precision = 8, scale = 2)
    private BigDecimal nroHoras;

    /** Cuotas para descuentos periódicos. */
    @Column(name = "nro_cuotas")
    private Integer nroCuotas;

    /** FK → rrhh.tipo_planilla (opcional, filtra por tipo de planilla). */
    @Column(name = "tipo_planilla_id")
    private Long tipoPlanillaId;
}
