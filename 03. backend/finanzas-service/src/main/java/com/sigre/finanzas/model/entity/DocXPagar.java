package com.sigre.finanzas.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "DOC_X_PAGAR")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocXPagar {

    @EmbeddedId
    private DocXPagarId id;

    @Column(name = "PROVEEDOR", length = 20)
    private String proveedor;

    @Column(name = "TIPO_DOC", length = 10)
    private String tipoDoc;

    @Column(name = "NRO_DOC", length = 20)
    private String nroDoc;

    @Column(name = "FECHA_EMI")
    private LocalDate fechaEmision;

    @Column(name = "FECHA_VEN")
    private LocalDate fechaVencimiento;

    @Column(name = "MONTO_ORIGINAL", precision = 18, scale = 2)
    private BigDecimal montoOriginal;

    @Column(name = "MONTO_PAGADO", precision = 18, scale = 2)
    private BigDecimal montoPagado;

    @Column(name = "SALDO", precision = 18, scale = 2)
    private BigDecimal saldo;

    @Column(name = "MONEDA", length = 3)
    private String moneda;

    @Column(name = "CONCEPTO_FIN", length = 20)
    private String conceptoFinanciero;

    @Column(name = "GLOSA", length = 500)
    private String glosa;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado; // P=Pendiente, C=Cancelado, A=Anulado

    @Column(name = "ORIGEN", length = 20)
    private String origen; // COMPRAS, RRHH, SERVICIOS
}

