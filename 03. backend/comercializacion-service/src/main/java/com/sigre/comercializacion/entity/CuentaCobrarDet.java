package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entidad JPA para Detalles de Cuentas por Cobrar (Movimientos)
 * Tabla: ventas.cntas_cobrar_det
 */
@Entity
@Table(name = "cntas_cobrar_det", schema = "ventas")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class CuentaCobrarDet extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cntas_cobrar_id", nullable = false, referencedColumnName = "id")
    private CuentaCobrar cuentaCobrar;

    @Column(name = "cntas_cobrar_id", insertable = false, updatable = false)
    private Long cntasCobrarId;

    @Column(name = "fecha_mov", nullable = false)
    private LocalDate fechaMov;

    @Enumerated(EnumType.STRING)
    @Column(name = "tipo_mov", nullable = false, length = 20)
    private TipoMovimiento tipoMov;

    @Column(name = "monto", nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(name = "referencia", length = 120)
    private String referencia;

    @Column(name = "concepto_financiero_id", nullable = false)
    private Long conceptoFinancieroId;

    @Column(name = "nro_item", nullable = false)
    private Integer nroItem;

    @Column(name = "descripcion", length = 2000)
    private String descripcion;

    @Column(name = "credito_fiscal_id", nullable = false)
    private Long creditoFiscalId;

    @Column(name = "cantidad", nullable = false, precision = 12, scale = 4)
    private BigDecimal cantidad = BigDecimal.ZERO;

    @Column(name = "precio_unitario", nullable = false, precision = 17, scale = 8)
    private BigDecimal precioUnitario = BigDecimal.ZERO;

    // Enum para tipos de movimiento
    public enum TipoMovimiento {
        CARGO,
        ABONO,
        AJUSTE
    }
}
