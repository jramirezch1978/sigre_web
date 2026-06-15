package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "caja_bancos", schema = "finanzas",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = "nro_registro")
    }
)
public class CajaBancos extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "nro_registro", nullable = false, unique = true, length = 12)
    private String nroRegistro;

    @Column(name = "fecha_emision")
    private LocalDate fechaEmision;

    @Column(name = "fecha_programada")
    private LocalDate fechaProgramada;

    @Column(name = "fecha_ejecucion")
    private LocalDate fechaEjecucion;

    @Column(name = "flag_pago", length = 1)
    private String flagPago;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "imp_total", precision = 18, scale = 4)
    private BigDecimal impTotal = BigDecimal.ZERO;

    @Column(name = "imp_asignado", precision = 18, scale = 4)
    private BigDecimal impAsignado = BigDecimal.ZERO;

    @Column(name = "registro_ref_id")
    private Long registroRefId;

    @Column
    private Integer impreso;

    @Column(name = "banco_cnta_id")
    private Long bancoCntaId;

    @Column(name = "banco_cnta_ref_id")
    private Long bancoCntaRefId;

    @Column(name = "reg_cheque")
    private Integer regCheque;

    @Column(name = "fecha_cobro_chq")
    private LocalDate fechaCobroChq;

    @Column(name = "concepto_financiero_id", nullable = false)
    private Long conceptoFinancieroId;

    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "cntbl_libro_id", nullable = false)
    private Long cntblLibroId;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

    @Column(name = "flag_tipo_transaccion", length = 1)
    private String flagTipoTransaccion;

    @Column(length = 500)
    private String observacion;

    @Column(name = "flag_adelanto", length = 1)
    private String flagAdelanto = "0";

    @Column(name = "doc_tipo_id")
    private Long docTipoId;

    @Column(name = "nro_doc", length = 12)
    private String nroDoc;

    @Column(name = "flag_conciliacion", length = 1)
    private String flagConciliacion;

    @Column(name = "tasa_cambio", precision = 11, scale = 8)
    private BigDecimal tasaCambio = BigDecimal.ZERO;

    @Column(name = "medio_pago_id")
    private Long medioPagoId;

    @Column(name = "flag_padron_sunat", length = 1)
    private String flagPadronSunat;

    @Column(name = "facturacion_simpl_id")
    private Long facturacionSimplId;

    @Column(name = "flag_forma_pago_fs", length = 1)
    private String flagFormaPagoFs;

    @Column(name = "fact_simpl_pago_id")
    private Long factSimplPagoId;

    @OneToMany(mappedBy = "cajaBancos", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CajaBancosDet> detalles = new ArrayList<>();

    public void addDetalle(CajaBancosDet detalle) {
        detalles.add(detalle);
        detalle.setCajaBancos(this);
    }

    public void removeDetalle(CajaBancosDet detalle) {
        detalles.remove(detalle);
        detalle.setCajaBancos(null);
    }

    public void clearDetalles() {
        detalles.forEach(detalle -> detalle.setCajaBancos(null));
        detalles.clear();
    }
}
