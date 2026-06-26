package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Períodos de planilla por planta, tipo de trabajador y tipo de planilla.
 * SIGRE: RRHH_PARAM_ORG.
 * Seed inicial: ddl/seed/06-seed-fechas-proceso-sigre.sql (1821 filas).
 */
@Entity
@Table(name = "fechas_proceso", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FechasProceso extends BaseEntity {

    /** Código de planta/sucursal: 'PI' (Piura), 'LM' (Lima), etc. */
    @Column(name = "origen", nullable = false, length = 5)
    private String origen;

    /** Fecha de proceso de planilla (primer día del mes, típicamente). */
    @Column(name = "fec_proceso", nullable = false)
    private LocalDate fecProceso;

    /** Primer día del período liquidado. */
    @Column(name = "fec_inicio", nullable = false)
    private LocalDate fecInicio;

    /** Último día del período liquidado. */
    @Column(name = "fec_final", nullable = false)
    private LocalDate fecFinal;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";

    @Column(name = "cod_relacion", nullable = false, length = 20)
    private String codRelacion;

    /** FK → rrhh.tipo_trabajador (EMP, JOR, TRI…). */
    @Column(name = "tipo_trabajador_id", nullable = false)
    private Long tipoTrabajadorId;

    @Column(name = "porc_aplica_ctacte", precision = 18, scale = 4)
    private BigDecimal porcAplicaCtacte;

    @Column(name = "flag_calc_vacaciones", nullable = false, length = 1)
    private String flagCalcVacaciones = "0";

    @Column(name = "flag_calc_cts", nullable = false, length = 1)
    private String flagCalcCts = "0";

    @Column(name = "flag_calc_gratificacion", nullable = false, length = 1)
    private String flagCalcGratificacion = "0";

    @Column(name = "flag_bonificacion_pesca", nullable = false, length = 1)
    private String flagBonificacionPesca = "0";

    /** FK → rrhh.tipo_planilla. */
    @Column(name = "tipo_planilla_id", nullable = false)
    private Long tipoPlanillaId;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
