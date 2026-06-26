package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "retencion", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(name = "UQ_RETENCION_01", columnNames = "nro_certificado"))
@EntityListeners(AuditingEntityListener.class)
public class Retencion extends BaseEntity {

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "nro_certificado", nullable = false, length = 15)
    private String nroCertificado;

    @Column(name = "fecha_emision")
    private LocalDate fechaEmision;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "proveedor_id", nullable = false)
    private Long proveedorId;

    /** FK obligatoria a finanzas.caja_bancos.id (columna legacy nro_reg_caja_ban). */
    @Column(name = "nro_reg_caja_ban", nullable = false)
    private Long nroRegCajaBan;

    @Column(name = "flag_tabla", length = 1)
    private String flagTabla;

    @Column(name = "saldo_sol", nullable = false, precision = 13, scale = 2)
    private BigDecimal saldoSol = BigDecimal.ZERO;

    @Column(name = "saldo_dol", nullable = false, precision = 13, scale = 2)
    private BigDecimal saldoDol = BigDecimal.ZERO;

    @Column(name = "importe_doc", nullable = false, precision = 13, scale = 2)
    private BigDecimal importeDoc = BigDecimal.ZERO;

    @Column(name = "fec_pago")
    private LocalDate fecPago;

    @Column(name = "tasa_cambio", nullable = false, precision = 7, scale = 4)
    private BigDecimal tasaCambio = BigDecimal.ONE;
}
