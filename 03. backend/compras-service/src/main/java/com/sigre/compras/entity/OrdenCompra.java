package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "orden_compra", schema = "compras")
public class OrdenCompra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "proveedor_id", nullable = false)
    private Long proveedorId;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;

    @Column(name = "nro_orden_compra", nullable = false, length = 12)
    private String nroOrdenCompra;

    @Column(name = "fecha_entrega")
    private LocalDate fechaEntrega;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "forma_pago_id")
    private Long formaPagoId;

    @Column(name = "entidad_banco_cnta_id")
    private Long entidadBancoCntaId;

    @Column(name = "lugar_entrega", length = 300)
    private String lugarEntrega;

    @Column(name = "observaciones", length = 2000)
    private String observaciones;

    @Column(name = "tipo_cambio", precision = 10, scale = 4)
    private BigDecimal tipoCambio;

    @Column(name = "subtotal", precision = 18, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "descuento_total", precision = 18, scale = 4)
    private BigDecimal descuentoTotal = BigDecimal.ZERO;

    @Column(name = "igv_total", precision = 18, scale = 4)
    private BigDecimal igvTotal = BigDecimal.ZERO;

    @Column(name = "percepcion_total", precision = 18, scale = 4)
    private BigDecimal percepcionTotal = BigDecimal.ZERO;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal total = BigDecimal.ZERO;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(name = "flag_importacion", length = 1)
    private String flagImportacion = "0";

    @Column(name = "flag_solicita_dua", length = 1)
    private String flagSolicitaDua = "0";

    @Column(name = "banco_id")
    private Long bancoId;

    @Column(name = "nro_cuenta", length = 30)
    private String nroCuenta;

    @Column(name = "centro_beneficio", length = 20)
    private String centroBeneficio;

    @Column(name = "comprador_id")
    private Long compradorId;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(name = "fecha_aprobacion")
    private OffsetDateTime fechaAprobacion;

    @Column(name = "motivo_anulacion", columnDefinition = "TEXT")
    private String motivoAnulacion;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @OneToMany(mappedBy = "ordenCompra", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrdenCompraDet> lineas = new ArrayList<>();

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }

    public void addLinea(OrdenCompraDet det) {
        lineas.add(det);
        det.setOrdenCompra(this);
    }
}
