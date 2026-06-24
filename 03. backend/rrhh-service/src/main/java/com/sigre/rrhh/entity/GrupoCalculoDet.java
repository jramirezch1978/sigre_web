package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

/**
 * Catálogo SIGRE GRUPO_CALCULO_DET — conceptos que pertenecen a un grupo de cálculo.
 * Seed inicial: ddl/seed/08-seed-grupo-calculo-det-sigre.sql (1033 filas).
 */
@Entity
@Table(name = "grupo_calculo_det", schema = "rrhh",
    uniqueConstraints = @UniqueConstraint(name = "UQ_GRUPO_CALCULO_DET",
        columnNames = {"grupo_calculo_id", "concepto_planilla_id"}))
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GrupoCalculoDet extends BaseEntity {

    @Column(name = "grupo_calculo_id", nullable = false)
    private Long grupoCalculoId;

    @Column(name = "concepto_planilla_id", nullable = false)
    private Long conceptoPlanillaId;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
