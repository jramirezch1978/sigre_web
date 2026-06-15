package com.sigre.common.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

/**
 * Entidad base para tablas que requieren seguimiento de sucursal.
 * Extiende BaseEntity agregando sucursal_id para tablas operativas.
 */
@Getter
@Setter
@MappedSuperclass
public abstract class BaseAuditableEntity extends BaseEntity {

    @Column(name = "sucursal_id")
    private Long sucursalId;
}
