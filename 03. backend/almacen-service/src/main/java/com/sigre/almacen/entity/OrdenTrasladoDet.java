package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "orden_traslado_det", schema = "almacen")
public class OrdenTrasladoDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "orden_traslado_id", nullable = false)
    private Long ordenTrasladoId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "cantidad_despachada", precision = 18, scale = 4)
    private BigDecimal cantidadDespachada = BigDecimal.ZERO;

    @Column(name = "cantidad_recibida", precision = 18, scale = 4)
    private BigDecimal cantidadRecibida = BigDecimal.ZERO;

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
        if (cantidadDespachada == null) {
            cantidadDespachada = BigDecimal.ZERO;
        }
        if (cantidadRecibida == null) {
            cantidadRecibida = BigDecimal.ZERO;
        }
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
