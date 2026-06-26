package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

/**
 * Proyección y retención de quinta categoría por trabajador y fecha de proceso.
 * Esquema alineado a SIGRE QUINTA_CATEGORIA (adaptado a FKs PostgreSQL).
 */
@Entity
@Table(name = "quinta_categoria", schema = "rrhh")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuintaCategoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "fec_proceso", nullable = false)
    private LocalDate fecProceso;

    @Column(name = "rem_proyectable", nullable = false, precision = 13, scale = 2)
    private BigDecimal remProyectable;

    @Column(name = "rem_imprecisa", nullable = false, precision = 13, scale = 2)
    private BigDecimal remImprecisa;

    @Column(name = "rem_retencion", nullable = false, precision = 13, scale = 2)
    private BigDecimal remRetencion;

    @Column(name = "rem_gratif", nullable = false, precision = 13, scale = 2)
    private BigDecimal remGratif;

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion;

    @Column(name = "nro_dias", nullable = false)
    private Short nroDias;

    @Column(name = "sueldo", nullable = false, precision = 13, scale = 2)
    private BigDecimal sueldo;

    @Column(name = "flag_automatico", nullable = false, length = 1)
    private String flagAutomatico;

    @Column(name = "gratif_proyect", nullable = false, precision = 13, scale = 2)
    private BigDecimal gratifProyect;

    @Column(name = "rem_externa", nullable = false, precision = 13, scale = 2)
    private BigDecimal remExterna;

    @Column(name = "tipo_planilla_id", nullable = false)
    private Long tipoPlanillaId;

    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
