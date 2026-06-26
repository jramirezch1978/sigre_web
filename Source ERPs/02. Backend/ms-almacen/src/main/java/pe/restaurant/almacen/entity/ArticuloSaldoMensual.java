package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "articulo_saldo_mensual", schema = "almacen")
public class ArticuloSaldoMensual {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "vale_mov_det_id")
    private Long valeMovDetId;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, length = 20)
    private String tipo;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "costo_unitario", nullable = false, precision = 18, scale = 6)
    private BigDecimal costoUnitario;

    @Column(name = "costo_total", nullable = false, precision = 18, scale = 4)
    private BigDecimal costoTotal;

    @Column(name = "saldo_cantidad", nullable = false, precision = 18, scale = 4)
    private BigDecimal saldoCantidad;

    @Column(name = "saldo_costo_unitario", precision = 18, scale = 6)
    private BigDecimal saldoCostoUnitario;

    @Column(name = "saldo_costo_total", precision = 18, scale = 4)
    private BigDecimal saldoCostoTotal;

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
        fecCreacion = OffsetDateTime.now();
        if (createdBy == null) {
            Long usuarioId = TenantContext.getUsuarioId();
            createdBy = (usuarioId != null) ? usuarioId : USUARIO_SISTEMA;
        }
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
