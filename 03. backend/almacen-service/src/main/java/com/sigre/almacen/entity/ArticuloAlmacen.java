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
@Table(name = "articulo_almacen", schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"almacen_id", "articulo_id"}))
public class ArticuloAlmacen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "cantidad_disponible", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidadDisponible = BigDecimal.ZERO;

    @Column(name = "cantidad_reservada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidadReservada = BigDecimal.ZERO;

    @Column(name = "costo_promedio", nullable = false, precision = 18, scale = 6)
    private BigDecimal costoPromedio = BigDecimal.ZERO;

    @Column(name = "ultima_actualizacion")
    private OffsetDateTime ultimaActualizacion;

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
        ultimaActualizacion = OffsetDateTime.now();
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        ultimaActualizacion = OffsetDateTime.now();
        fecModificacion = OffsetDateTime.now();
    }
}
