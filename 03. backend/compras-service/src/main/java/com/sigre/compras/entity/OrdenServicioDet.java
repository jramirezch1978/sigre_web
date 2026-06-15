package com.sigre.compras.entity;

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
@Table(name = "orden_servicio_det", schema = "compras")
public class OrdenServicioDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "orden_servicio_id", nullable = false)
    private OrdenServicio ordenServicio;

    @Column(name = "nro_item", nullable = false)
    private Integer nroItem;

    @Column(name = "servicio_id", nullable = false)
    private Long servicioId;

    @Column(name = "descripcion", length = 2000)
    private String descripcion;

    @Column(name = "fec_proyect")
    private LocalDate fecProyect;

    @Column(name = "fec_fin_servicio")
    private LocalDate fecFinServicio;

    @Column(name = "importe", nullable = false, precision = 18, scale = 4)
    private BigDecimal importe;

    @Column(name = "descto_porcentaje", precision = 7, scale = 4)
    private BigDecimal dsctoPorcentaje = BigDecimal.ZERO;

    @Column(name = "decuento", precision = 18, scale = 4)
    private BigDecimal decuento = BigDecimal.ZERO;

    @Column(name = "tipos_impuesto_id")
    private Long tiposImpuestoId;

    @Column(name = "impuesto", precision = 18, scale = 4)
    private BigDecimal impuesto = BigDecimal.ZERO;

    @Column(name = "tipos_impuesto2_id")
    private Long tiposImpuesto2Id;

    @Column(name = "impuesto2", precision = 18, scale = 4)
    private BigDecimal impuesto2 = BigDecimal.ZERO;

    @Column(name = "subtotal", precision = 18, scale = 4)
    private BigDecimal subtotal = BigDecimal.ZERO;

    @Column(name = "imp_provisionado", precision = 18, scale = 4)
    private BigDecimal impProvisionado = BigDecimal.ZERO;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "concepto_financiero_id")
    private Long conceptoFinancieroId;

    @Column(name = "operaciones_det_id")
    private Long operacionesDetId;

    @Column(name = "conformidad_fecha")
    private OffsetDateTime conformidadFecha;

    @Column(name = "conformidad_usr")
    private Long conformidadUsr;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(name = "fec_aprobacion")
    private OffsetDateTime fecAprobacion;

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
