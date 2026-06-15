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
@Table(name = "labor_insumo", schema = "produccion")
public class LaborInsumo extends AuditOnlyMappedEntity {

    @Column(name = "labor_id", nullable = false)
    private Long laborId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;
}
