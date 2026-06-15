package com.sigre.common.entity;

import jakarta.persistence.EntityListeners;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;

/**
 * Maestros u otras tablas con auditoría estándar pero sin columna {@code flag_estado}
 * según DDL canónico (p. ej. {@code contabilidad.cntbl_libro}, {@code ventas.proforma_det}).
 * No usar en entidades cuyas tablas declaren {@code flag_estado} (usar {@link BaseEntity}).
 */
@Getter
@Setter
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class AuditOnlyMappedEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @CreatedBy
    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @CreatedDate
    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @LastModifiedBy
    @Column(name = "updated_by")
    private Long updatedBy;

    @LastModifiedDate
    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
