package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "articulo_almacen_lote", schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"almacen_id", "articulo_id", "lote_pallet_id"}))
public class ArticuloAlmacenLote {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "lote_pallet_id", nullable = false)
    private Long lotePalletId;

    /** Acumulado de ingresos al lote (solo crece con entradas). */
    @Column(name = "cantidad_total", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidadTotal = BigDecimal.ZERO;

    /** Saldo disponible del lote. Σ saldo por lote debe cuadrar con articulo_almacen.cantidad_disponible. */
    @Column(name = "saldo", nullable = false, precision = 18, scale = 4)
    private BigDecimal saldo = BigDecimal.ZERO;

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

    /** Usuario de sistema usado como respaldo (coincide con el DEFAULT 1 de la columna created_by). */
    private static final Long USUARIO_SISTEMA = 1L;

    @PrePersist
    void prePersist() {
        ultimaActualizacion = OffsetDateTime.now();
        fecCreacion = OffsetDateTime.now();
        if (createdBy == null) {
            Long usuarioId = TenantContext.getUsuarioId();
            createdBy = (usuarioId != null) ? usuarioId : USUARIO_SISTEMA;
        }
    }

    @PreUpdate
    void preUpdate() {
        ultimaActualizacion = OffsetDateTime.now();
        fecModificacion = OffsetDateTime.now();
    }
}
