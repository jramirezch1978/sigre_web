package com.sigre.rrhh.entity;

import com.sigre.common.entity.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "grupo_conceptos_seccion", schema = "rrhh")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class GrupoConceptosSeccion extends BaseEntity {

    @Column(name = "grupo_calculo_id", nullable = false)
    private Long grupoCalculoId;

    @Column(name = "seccion_id", nullable = false)
    private Long seccionId;
}
