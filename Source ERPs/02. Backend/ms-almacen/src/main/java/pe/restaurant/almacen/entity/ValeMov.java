package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.security.TenantContext;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "vale_mov", schema = "almacen")
public class ValeMov {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "articulo_mov_tipo_id", nullable = false)
    private Long articuloMovTipoId;

    @Column(name = "fecha_mov", nullable = false)
    private LocalDate fechaMov;

    @Column(name = "nro_vale", nullable = false, length = 12)
    private String nroVale;

    @Column(name = "fec_produccion")
    private LocalDate fecProduccion;

    @Column(name = "proveedor_id")
    private Long proveedorId;

    @Column(name = "nom_receptor", length = 120)
    private String nomReceptor;

    @Column(name = "tipo_doc_int_id")
    private Long tipoDocIntId;

    @Column(name = "nro_doc_int", length = 20)
    private String nroDocInt;

    @Column(name = "tipo_doc_ext_id")
    private Long tipoDocExtId;

    @Column(name = "nro_doc_ext", length = 20)
    private String nroDocExt;

    @Column(name = "orden_compra_id")
    private Long ordenCompraId;

    @Column(name = "prog_compras_id")
    private Long progComprasId;

    @Column(name = "orden_traslado_id")
    private Long ordenTrasladoId;

    @Column(name = "orden_trabajo_id")
    private Long ordenTrabajoId;

    @Column(name = "orden_venta_id")
    private Long ordenVentaId;

    @Column(name = "tipo_referencia_origen", length = 1)
    private String tipoReferenciaOrigen;

    @Column(length = 3000)
    private String observaciones;

    @Column(name = "vale_mov_orig_id")
    private Long valeMovOrigId;

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

    @OneToMany(mappedBy = "valeMov", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ValeMovDet> lineas = new ArrayList<>();

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
        updatedBy = TenantContext.getUsuarioId();
    }

    public void addLinea(ValeMovDet det) {
        lineas.add(det);
        det.setValeMov(this);
    }
}
