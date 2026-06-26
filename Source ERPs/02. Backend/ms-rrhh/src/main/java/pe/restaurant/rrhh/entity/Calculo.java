package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

/**
 * Cabecera de boleta de pagos (planilla por trabajador y fecha de proceso).
 */
@Entity
@Table(name = "calculo", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Calculo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "fec_proceso", nullable = false)
    private LocalDate fecProceso;

    @Column(name = "fec_inicio")
    private LocalDate fecInicio;

    @Column(name = "fec_final")
    private LocalDate fecFinal;

    @Column(name = "tipo_planilla_id", nullable = false)
    private Long tipoPlanillaId;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "tipo_cambio", precision = 18, scale = 6)
    private BigDecimal tipoCambio;

    @Column(name = "dias_trabajados", precision = 6, scale = 2)
    private BigDecimal diasTrabajados;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "periodo", length = 9)
    private String periodo;

    @Column(name = "flag_replicacion", length = 1)
    private String flagReplicacion;

    @Column(name = "total_ingresos_soles", precision = 18, scale = 5)
    private BigDecimal totalIngresosSoles;

    @Column(name = "total_descuentos_soles", precision = 18, scale = 5)
    private BigDecimal totalDescuentosSoles;

    @Column(name = "total_neto_soles", precision = 18, scale = 5)
    private BigDecimal totalNetoSoles;

    @Column(name = "total_aportes_soles", precision = 18, scale = 5)
    private BigDecimal totalAportesSoles;

    @Column(name = "total_ingresos_dolar", precision = 18, scale = 5)
    private BigDecimal totalIngresosDolar;

    @Column(name = "total_descuentos_dolar", precision = 18, scale = 5)
    private BigDecimal totalDescuentosDolar;

    @Column(name = "total_neto_dolar", precision = 18, scale = 5)
    private BigDecimal totalNetoDolar;

    @Column(name = "total_aportes_dolar", precision = 18, scale = 5)
    private BigDecimal totalAportesDolar;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
