package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

/**
 * Ganancias y descuentos fijos del trabajador (sueldo base, AF, asignaciones fijas).
 * SIGRE: GAN_DESCT_FIJO — un registro por concepto activo del trabajador.
 */
@Entity
@Table(name = "gan_desct_fijo", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDesctFijo extends BaseEntity {

    /** FK → rrhh.trabajador. */
    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    /** FK → rrhh.concepto_planilla. */
    @Column(name = "concepto_id", nullable = false)
    private Long conceptoId;

    /** Importe fijo en soles (sueldo, descuento mensual, etc.). */
    @Column(name = "imp_gan_desc", precision = 18, scale = 4)
    private BigDecimal impGanDesc;

    /** Porcentaje alternativo al importe (ej. % descuento fijo sobre total ingresos). */
    @Column(name = "porcentaje", precision = 8, scale = 4)
    private BigDecimal porcentaje;

    /** Tope máximo aplicable cuando se usa porcentaje. */
    @Column(name = "imp_max_gan_desc", precision = 18, scale = 4)
    private BigDecimal impMaxGanDesc;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
