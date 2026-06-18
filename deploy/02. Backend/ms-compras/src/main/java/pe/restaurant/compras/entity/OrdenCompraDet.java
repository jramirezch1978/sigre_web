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
@Table(name = "orden_compra_det", schema = "compras")
public class OrdenCompraDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "orden_compra_id", nullable = false)
    private OrdenCompra ordenCompra;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "cant_proyectada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantProyectada;

    @Column(name = "fec_proyectada")
    private LocalDate fecProyectada;

    @Column(name = "cant_procesada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantProcesada = BigDecimal.ZERO;

    @Column(name = "cant_facturada", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantFacturada = BigDecimal.ZERO;

    @Column(name = "valor_unitario", nullable = false, precision = 18, scale = 6)
    private BigDecimal valorUnitario;

    @Column(name = "tipo_impuesto_id")
    private Long tipoImpuestoId;

    @Column(name = "valor_impuesto", precision = 18, scale = 4)
    private BigDecimal valorImpuesto = BigDecimal.ZERO;

    @Column(name = "descuento_porcentaje", precision = 7, scale = 4)
    private BigDecimal descuentoPorcentaje = BigDecimal.ZERO;

    @Column(name = "descuento_monto", precision = 18, scale = 4)
    private BigDecimal descuentoMonto = BigDecimal.ZERO;

    @Column(name = "tipo_percepcion_id")
    private Long tipoPercepcionId;

    @Column(name = "percepcion_monto", precision = 18, scale = 4)
    private BigDecimal percepcionMonto = BigDecimal.ZERO;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "almacen_id")
    private Long almacenId;

    @Column(name = "referencia_sol_compra_id")
    private Long referenciaSolCompraId;

    @Column(name = "fecha_entrega")
    private LocalDate fechaEntrega;

    @Column(name = "operaciones_det_id")
    private Long operacionesDetId;

    @Column(name = "prog_compras_det_id")
    private Long progComprasDetId;

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
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
