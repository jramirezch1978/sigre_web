package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "orden_traslado", schema = "almacen")
public class OrdenTraslado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_origen_id", nullable = false)
    private Long almacenOrigenId;

    @Column(name = "almacen_destino_id", nullable = false)
    private Long almacenDestinoId;

    /** Correlativo único; columna física {@code nro_orden_traslado} en DDL tenant. */
    @Column(name = "nro_orden_traslado", nullable = false, length = 12)
    private String numero;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    private String observacion;

    @Column(name = "usuario_id")
    private Long usuarioId;

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
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
