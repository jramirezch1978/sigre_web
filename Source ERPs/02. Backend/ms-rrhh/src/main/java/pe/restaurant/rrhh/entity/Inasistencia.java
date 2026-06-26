package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Registro SIGRE INASISTENCIA: trabajador, concepto, fechas, días, vacaciones adelantadas e importe.
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "inasistencia", schema = "rrhh")
public class Inasistencia extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_planilla_id")
    private Long conceptoPlanillaId;

    @Column(name = "fecha_desde", nullable = false)
    private LocalDate fechaDesde;

    @Column(name = "fecha_hasta")
    private LocalDate fechaHasta;

    @Column(name = "fecha_movimiento")
    private LocalDate fechaMovimiento;

    @Column(name = "dias_inasistencia", nullable = false)
    private BigDecimal diasInasistencia;

    @Column(name = "flag_vacaciones_adelantadas", nullable = false, length = 1)
    private String flagVacacionesAdelantadas;

    @Column(name = "importe", nullable = false)
    private BigDecimal importe;
}
