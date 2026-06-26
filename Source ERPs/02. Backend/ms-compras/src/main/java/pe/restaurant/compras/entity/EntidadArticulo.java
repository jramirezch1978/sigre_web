package pe.restaurant.compras.entity;

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
@Table(name = "entidad_articulo", schema = "compras")
public class EntidadArticulo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "precio_referencia", precision = 18, scale = 4)
    private BigDecimal precioReferencia;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado = "1";

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
