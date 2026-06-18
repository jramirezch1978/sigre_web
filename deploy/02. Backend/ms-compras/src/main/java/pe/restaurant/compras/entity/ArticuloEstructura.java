package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_estructura", schema = "compras")
@IdClass(ArticuloEstructuraId.class)
public class ArticuloEstructura {

    @Id
    @Column(name = "articulo_padre_id", nullable = false)
    private Long articuloPadreId;

    @Id
    @Column(name = "articulo_hijo_id", nullable = false)
    private Long articuloHijoId;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad = BigDecimal.ZERO;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion", updatable = false)
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @PrePersist
    protected void onCreate() {
        this.fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.fecModificacion = OffsetDateTime.now();
    }
}
