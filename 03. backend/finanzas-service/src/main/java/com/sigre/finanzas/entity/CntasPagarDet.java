package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cntas_pagar_det", schema = "finanzas")
public class CntasPagarDet extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cntas_pagar_id", nullable = false)
    private CntasPagar cntasPagar;

    @Column(nullable = false)
    private Integer item;

    @Column(name = "concepto_financiero_id", nullable = false)
    private Long conceptoFinancieroId;

    @Column(nullable = false, length = 2000)
    private String descripcion;

    @Column(name = "articulo_id")
    private Long articuloId;

    @Column(nullable = false, precision = 12, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "precio_unitario", nullable = false, precision = 17, scale = 8)
    private BigDecimal precioUnitario;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(name = "centros_costo_id", nullable = false)
    private Long centrosCostoId;

    @Column(name = "credito_fiscal_id", nullable = false)
    private Long creditoFiscalId;

    @Column(name = "orden_compra_det_id")
    private Long ordenCompraDetId;

    @Column(name = "orden_servicio_det_id")
    private Long ordenServicioDetId;

    @Column(name = "vale_mov_det_id")
    private Long valeMovDetId;

    @Column(name = "sucursal_ref_id")
    private Long sucursalRefId;

    @Column(name = "doc_tipo_ref_id")
    private Long docTipoRefId;

    @Column(name = "nro_ref", length = 12)
    private String nroRef;

    @Column(name = "item_ref")
    private Integer itemRef;

    @Column(name = "fec_movilidad")
    private LocalDate fecMovilidad;

    @Column(name = "mov_desde", length = 200)
    private String movDesde;

    @Column(name = "mov_hasta", length = 200)
    private String movHasta;

    @Column(name = "trabajador_id")
    private Long trabajadorId;

    @Column(name = "fecha_mov", nullable = false)
    private LocalDate fechaMov;

    @Column(name = "tipo_mov", nullable = false, length = 20)
    private String tipoMov;

    @Column(length = 120)
    private String referencia;

    @Transient
    private List<com.sigre.finanzas.dto.request.DetImpuestoRequest> impuestos;
}
