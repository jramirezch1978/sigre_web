package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "aprobacion", schema = "compras")
public class Aprobacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "documento_id", nullable = false)
    private Long documentoId;

    @Column(nullable = false)
    private Integer nivel = 1;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(length = 20)
    private String accion;

    @Column(columnDefinition = "TEXT")
    private String comentario;

    @Column
    private OffsetDateTime fecha;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
        if (fecha == null) fecha = OffsetDateTime.now();
    }
}
