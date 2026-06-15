package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Detalle de cálculo de planilla: una línea por trabajador/concepto.
 * No extiende BaseEntity ya que la tabla no posee columna flag_estado.
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

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_id", nullable = false)
    private Long conceptoId;

    @Column(name = "monto", nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(name = "tipo_concepto_calculo_id", nullable = false)
    private Long tipoConceptoCalculoId;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
