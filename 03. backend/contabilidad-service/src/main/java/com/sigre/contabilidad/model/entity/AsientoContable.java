package com.sigre.contabilidad.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entidad Asiento Contable - Tabla ASIENTO_CONTABLE
 * Almacena cada línea de un asiento contable
 */
@Entity
@Table(name = "ASIENTO_CONTABLE")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoContable {

    @EmbeddedId
    private AsientoContableId id;

    @Column(name = "FECHA_ASIENTO", nullable = false)
    private LocalDate fechaAsiento;

    @Column(name = "GLOSA", length = 500)
    private String glosa;

    @Column(name = "DEBE_MN", precision = 18, scale = 2)
    private BigDecimal debeMn;

    @Column(name = "HABER_MN", precision = 18, scale = 2)
    private BigDecimal haberMn;

    @Column(name = "DEBE_ME", precision = 18, scale = 2)
    private BigDecimal debeMe;

    @Column(name = "HABER_ME", precision = 18, scale = 2)
    private BigDecimal haberMe;

    @Column(name = "TIPO_CAMBIO", precision = 10, scale = 4)
    private BigDecimal tipoCambio;

    @Column(name = "TIPO_DOC", length = 10)
    private String tipoDoc;

    @Column(name = "NRO_DOC", length = 20)
    private String nroDoc;

    @Column(name = "FECHA_DOC")
    private LocalDate fechaDoc;

    @Column(name = "RUC", length = 20)
    private String ruc;

    @Column(name = "RAZON_SOCIAL", length = 200)
    private String razonSocial;

    @Column(name = "CENTRO_COSTO", length = 20)
    private String centroCosto;

    @Column(name = "PROYECTO", length = 20)
    private String proyecto;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado; // 1=Activo, 0=Anulado

    @Column(name = "FLAG_TRANSFERIDO", length = 1)
    private String flagTransferido; // S=Transferido, N=Pendiente

    @Column(name = "ORIGEN_INTEGRACION", length = 50)
    private String origenIntegracion; // ALM, VEN, RRHH, PROD, etc.

    // Relación con cuenta contable
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumns({
        @JoinColumn(name = "EMPRESA", referencedColumnName = "EMPRESA", insertable = false, updatable = false),
        @JoinColumn(name = "CNTA_CNTBL", referencedColumnName = "CNTA_CNTBL", insertable = false, updatable = false)
    })
    private PlanCuentas cuenta;
}

