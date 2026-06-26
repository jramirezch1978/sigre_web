package pe.restaurant.ventas.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entidad JPA para Cuentas por Cobrar
 * Tabla: ventas.cntas_cobrar
 */
@Entity
@Table(name = "cntas_cobrar", schema = "ventas")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class CuentaCobrar extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "cliente_id", nullable = false)
    private Long clienteId;

    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;

    @Column(name = "serie", length = 10)
    private String serie;

    @Column(name = "numero", length = 20)
    private String numero;

    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;

    @Column(name = "fecha_vencimiento")
    private LocalDate fechaVencimiento;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "tasa_cambio", nullable = false, precision = 11, scale = 4)
    private BigDecimal tasaCambio = BigDecimal.ONE;

    @Column(name = "total", nullable = false, precision = 18, scale = 4)
    private BigDecimal total = BigDecimal.ZERO;

    @Column(name = "saldo", nullable = false, precision = 18, scale = 4)
    private BigDecimal saldo = BigDecimal.ZERO;

    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "cntbl_libro_id", nullable = false)
    private Long cntblLibroId;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;
}
