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
@Table(name = "vale_mov_det", schema = "almacen")
public class ValeMovDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vale_mov_id", nullable = false)
    private ValeMov valeMov;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "cant_procesada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantProcesada;

    @Column(name = "costo_unitario", precision = 18, scale = 6)
    private BigDecimal costoUnitario;

    @Column(name = "matriz_contable_id")
    private Long matrizContableId;

    /**
     * FK lógica a {@code finanzas.concepto_financiero(id)}. Integración contable por concepto (Ruta B):
     * almacén envía el concepto a contabilidad, que resuelve la matriz contable. Nullable: el flujo
     * legacy (tipo_mov + grp_cntbl + cod_sub_cat) no la usa.
     */
    @Column(name = "concepto_financiero_id")
    private Long conceptoFinancieroId;

    @Column(name = "lote_pallet_id")
    private Long lotePalletId;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "peso_neto_tm", precision = 12, scale = 3)
    private BigDecimal pesoNetoTm = BigDecimal.ZERO;

    @Column(name = "precio_unit_ant", precision = 21, scale = 12)
    private BigDecimal precioUnitAnt;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "ubicacion_almacen_id")
    private Long ubicacionAlmacenId;

    @Column(name = "oc_det_id")
    private Long ocDetId;

    @Column(name = "orden_traslado_det_id")
    private Long ordenTrasladoDetId;

    @Column(name = "orden_venta_det_id")
    private Long ordenVentaDetId;

    @Column(name = "operaciones_det_id")
    private Long operacionesDetId;

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
}
