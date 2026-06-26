package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.security.TenantContext;

import java.time.OffsetDateTime;

/**
 * Configuración del almacén por defecto ("tácito") según la clase del artículo
 * ({@code cod_clase}) y la sucursal. Permite resolver automáticamente el almacén
 * destino/origen en procesos como órdenes de compra, sin selección manual.
 *
 * <p>Tabla maestra del schema {@code almacen} (dueño: ms-almacen, con CRUD de administración).
 * Consumida en solo lectura por ms-compras vía {@code AlmacenTacitoRef}
 * ({@code findFirstByCodClaseAndSucursalId}).
 */
@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "almacen_tacito", schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"cod_clase", "sucursal_id"}))
public class AlmacenTacito {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "cod_clase", nullable = false, length = 20)
    private String codClase;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "flag_estado", nullable = false, length = 1)
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
        if (createdBy == null) {
            createdBy = TenantContext.getUsuarioId();
        }
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
        updatedBy = TenantContext.getUsuarioId();
    }
}
