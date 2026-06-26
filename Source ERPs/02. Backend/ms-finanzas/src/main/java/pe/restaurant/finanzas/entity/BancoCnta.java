package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "banco_cnta", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(columnNames = {"cod_ctabco"}))
public class BancoCnta extends BaseEntity {

    @Column(name = "cod_ctabco", nullable = false, length = 30, unique = true)
    private String codigo;

    @Column(name = "plan_contable_det_id", nullable = false)
    private Long planContableDetId;

    @Column(name = "banco_id", nullable = false)
    private Long bancoId;

    @Column(name = "tipo_ctabco")
    private String tipoCtaBco;

    @Column(name = "descripcion", length = 200)
    private String descripcion;

    @Column(name = "correlativo_cheque")
    private Integer correlativoCheque;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "saldo_disponible", precision = 18, scale = 4)
    private BigDecimal saldoDisponible;

    @Column(name = "sldo_contable", precision = 18, scale = 4)
    private BigDecimal saldoContable;

    @Column(name = "sldo_bancario", precision = 18, scale = 4)
    private BigDecimal saldoBancario;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "flag_uso_interno", length = 1)
    private String flagUsoInterno = "0";

    @Column(name = "nro_cci", length = 30)
    private String nroCci;

    @Column(name = "flag_flujo_caja", length = 1)
    private String flagFlujoCaja = "1";

    @Column(name = "nro_cuenta", length = 30)
    private String nroCuenta;

    @Column(name = "flag_facturacion_simpl", length = 1)
    private String flagFacturacionSimpl = "1";

    @PrePersist
    protected void onCreate() {
        if (getFecCreacion() == null) {
            setFecCreacion(Instant.now());
        }
        flagUsoInterno = flagUsoInterno == null ? "0" : flagUsoInterno;
        flagFlujoCaja = flagFlujoCaja == null ? "1" : flagFlujoCaja;
        flagFacturacionSimpl = flagFacturacionSimpl == null ? "1" : flagFacturacionSimpl;
    }

    @PreUpdate
    protected void onUpdate() {
        setFecModificacion(Instant.now());
    }
}
