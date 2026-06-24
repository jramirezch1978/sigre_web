package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "cnta_crrte", schema = "rrhh")
public class CntaCrrte extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "nro_doc", nullable = false, length = 20)
    private String nroDoc;

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "cntas_cobrar_id")
    private Long cntasCobrarId;

    @Column(name = "concepto_planilla_id", nullable = false)
    private Long conceptoPlanillaId;

    @Column(name = "fec_prestamo", nullable = false)
    private LocalDate fecPrestamo;

    @Column(name = "fecha_inicio_descuento")
    private LocalDate fechaInicioDescuento;

    @Column(name = "nro_cuotas", nullable = false)
    private Short nroCuotas = 1;

    @Column(name = "monto_original", nullable = false, precision = 18, scale = 5)
    private BigDecimal montoOriginal = BigDecimal.ZERO;

    @Column(name = "monto_cuota", nullable = false, precision = 18, scale = 5)
    private BigDecimal montoCuota = BigDecimal.ZERO;

    @Column(name = "saldo_prestamo", nullable = false, precision = 18, scale = 5)
    private BigDecimal saldoPrestamo = BigDecimal.ZERO;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;
}
