package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_mov_tipo", schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"tipo_mov"}))
public class ArticuloMovTipo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tipo_mov", nullable = false, length = 10)
    private String tipoMov;

    @Column(name = "desc_tipo_mov", nullable = false, length = 200)
    private String descTipoMov;

    @Column(name = "flag_contabiliza", nullable = false, length = 1)
    private String flagContabiliza = "0";

    @Column(name = "flag_ajuste_valorizacion", nullable = false, length = 1)
    private String flagAjusteValorizacion = "0";

    @Column(name = "flag_mov_entre_alm", nullable = false, length = 1)
    private String flagMovEntreAlm = "0";

    @Column(name = "flag_solicita_prov", nullable = false, length = 1)
    private String flagSolicitaProv = "0";

    @Column(name = "flag_solicita_doc_int", nullable = false, length = 1)
    private String flagSolicitaDocInt = "0";

    @Column(name = "flag_solicita_doc_ext", nullable = false, length = 1)
    private String flagSolicitaDocExt = "0";

    @Column(name = "flag_solicita_ref", nullable = false, length = 1)
    private String flagSolicitaRef = "0";

    @Column(name = "factor_sldo_total", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorSldoTotal = BigDecimal.ZERO;

    @Column(name = "factor_sldo_x_llegar", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorSldoXLlegar = BigDecimal.ZERO;

    @Column(name = "factor_sldo_sol", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorSldoSol = BigDecimal.ZERO;

    @Column(name = "factor_sldo_dev", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorSldoDev = BigDecimal.ZERO;

    @Column(name = "factor_sldo_pres", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorSldoPres = BigDecimal.ZERO;

    @Column(name = "factor_sldo_consig", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorSldoConsig = BigDecimal.ZERO;

    @Column(name = "factor_ctrl_templa", nullable = false, precision = 10, scale = 2)
    private BigDecimal factorCtrlTempla = BigDecimal.ZERO;

    @Column(name = "flag_clase_mov", length = 1)
    private String flagClaseMov;

    @Column(name = "flag_solicita_lote", nullable = false, length = 1)
    private String flagSolicitaLote = "0";

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(name = "flag_solicita_precio", nullable = false, length = 1)
    private String flagSolicitaPrecio = "0";

    @Column(name = "tipo_mov_dev", length = 10)
    private String tipoMovDev;

    @Column(name = "flag_amp", nullable = false, length = 1)
    private String flagAmp = "0";

    @Column(name = "factor_sldo_reservado", precision = 10, scale = 2)
    private BigDecimal factorSldoReservado;

    @Column(name = "flag_solicita_cenbef", nullable = false, length = 1)
    private String flagSolicitaCenbef = "0";

    @Column(name = "flag_cntrl_cta_cte", length = 1)
    private String flagCntrlCtaCte;

    @Column(name = "flag_cambia_precio", nullable = false, length = 1)
    private String flagCambiaPrecio = "0";

    @Column(name = "cod_sunat", length = 10)
    private String codSunat;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion", updatable = false)
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @PrePersist
    protected void onCreate() {
        fecCreacion = OffsetDateTime.now();
        if (createdBy == null) {
            createdBy = TenantContext.getUsuarioId();
        }
    }

    @PreUpdate
    protected void onUpdate() {
        fecModificacion = OffsetDateTime.now();
        updatedBy = TenantContext.getUsuarioId();
    }
}
