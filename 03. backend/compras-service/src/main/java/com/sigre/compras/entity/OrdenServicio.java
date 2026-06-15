package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "orden_servicio", schema = "compras")
public class OrdenServicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "cod_origen", length = 10)
    private String codOrigen;

    @Column(name = "nro_os", length = 30)
    private String nroOs;

    @Column(name = "proveedor_id", nullable = false)
    private Long proveedorId;

    @Column(name = "nom_vendedor", length = 300)
    private String nomVendedor;

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "entidad_direccion_id")
    private Long entidadDireccionId;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fecRegistro;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "tipo_cambio", precision = 10, scale = 4)
    private BigDecimal tipoCambio;

    @Column(name = "forma_pago_id")
    private Long formaPagoId;

    @Column(name = "flag_req_serv", length = 1)
    private String flagReqServ = "0";

    @Column(name = "flag_cotizacion", nullable = false, length = 1)
    private String flagCotizacion = "0";

    @Column(name = "flag_solicita_acta", length = 1)
    private String flagSolicitaActa = "0";

    @Column(name = "orden_trabajo_id")
    private Long ordenTrabajoId;

    @Column(name = "banco_id")
    private Long bancoId;

    @Column(name = "nro_cuenta", length = 30)
    private String nroCuenta;

    @Column(name = "monto_facturado", precision = 18, scale = 4)
    private BigDecimal montoFacturado = BigDecimal.ZERO;

    @Column(name = "monto_conforme", precision = 18, scale = 4)
    private BigDecimal montoConforme = BigDecimal.ZERO;

    @Column(name = "total", precision = 18, scale = 4)
    private BigDecimal montoTotal = BigDecimal.ZERO;

    @Column(name = "descripcion", length = 2000)
    private String descripcion;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(name = "comprador_id")
    private Long compradorId;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(name = "fecha_aprob")
    private LocalDateTime fechaAprob;

    @Column(name = "motivo_anulacion", columnDefinition = "TEXT")
    private String motivoAnulacion;

    @Column(name = "fecha_baja")
    private OffsetDateTime fechaBaja;

    @Column(name = "usr_baja")
    private Long usrBaja;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @OneToMany(mappedBy = "ordenServicio", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OrdenServicioDet> lineas = new ArrayList<>();

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }

    public void addLinea(OrdenServicioDet det) {
        lineas.add(det);
        det.setOrdenServicio(this);
    }
}
