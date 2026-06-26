package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "articulo_mov_proy", schema = "compras")
public class ArticuloMovProy {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "almacen_id")
    private Long almacenId;

    @Column(name = "orden_compra_det_id")
    private Long ordenCompraDetId;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "fecha_proyectada")
    private LocalDate fechaProyectada;

    @Column(name = "tipo_origen", length = 20)
    private String tipoOrigen = "OC";

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
