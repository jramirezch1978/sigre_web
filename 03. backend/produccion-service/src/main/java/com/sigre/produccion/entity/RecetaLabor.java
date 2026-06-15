package com.sigre.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.AuditOnlyMappedEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "receta_labor", schema = "produccion")
public class RecetaLabor extends AuditOnlyMappedEntity {

    @Column(name = "receta_id", nullable = false)
    private Long recetaId;

    @Column(name = "labor_id", nullable = false)
    private Long laborId;

    @Column(name = "secuencia", nullable = false)
    private Integer secuencia;

    @Column(name = "descripcion_paso")
    private String descripcionPaso;
}
