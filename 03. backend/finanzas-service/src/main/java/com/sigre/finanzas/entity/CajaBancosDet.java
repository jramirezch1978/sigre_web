package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "caja_bancos_det", schema = "finanzas")
public class CajaBancosDet extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "caja_bancos_id", nullable = false)
    private CajaBancos cajaBancos;

    @Column(nullable = false)
    private Integer item = 1;

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long entidadContribuyenteId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "nro_doc", nullable = false, length = 12)
    private String nroDoc;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal importe = BigDecimal.ZERO;

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "cntas_cobrar_id")
    private Long cntasCobrarId;

    @Column(name = "solicitud_giro_id")
    private Long solicitudGiroId;

    @Column(name = "liquidacion_id")
    private Long liquidacionId;

    @Column(name = "concepto_financiero_id")
    private Long conceptoFinancieroId;

    @Column(name = "flag_cxp", length = 1)
    private String flagCxp;

    @Column(name = "sucursal_ref_id")
    private Long sucursalRefId;

    @Column(name = "impt_ret_igv", precision = 18, scale = 4)
    private BigDecimal imptRetIgv = BigDecimal.ZERO;

    @Column(name = "flag_ret_igv", length = 1)
    private String flagRetIgv = "0";

    @Column(name = "flag_referencia", length = 1)
    private String flagReferencia;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "flag_flujo_caja", length = 1)
    private String flagFlujoCaja = "1";

    @Column
    private Integer factor = 0;

    @Column(name = "flag_provisionado", length = 1)
    private String flagProvisionado;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "flag_aplic_comp", length = 1)
    private String flagAplicComp = "0";

    @Column(name = "codigo_flujo_caja_id")
    private Long codigoFlujoCajaId;

    @Column(name = "banco_cnta_prov_id")
    private Long bancoCntaProvId;
}
