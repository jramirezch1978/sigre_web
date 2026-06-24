package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

/**
 * Catálogo SIGRE GRUPO_CALC_CONCEPTO (GRUPO_CALC_CONCEPTO.json).
 */
@Getter
@Setter
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "grupo_conceptos_planilla", schema = "rrhh",
    uniqueConstraints = {
        @UniqueConstraint(name = "UQ_GRUPO_CONCEPTOS_PLANILLA_CODIGO", columnNames = "codigo")
    }
)
public class GrupoConceptosPlanilla extends BaseEntity {

    @Column(name = "codigo", nullable = false, length = 10)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "concepto_codigo", length = 20)
    private String conceptoCodigo;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";
}
