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
 * Entidad que representa un registro de ganancia o descuento variable
 * asociado a un trabajador y un concepto de planilla.
 * No extiende BaseEntity porque la tabla no tiene columna flag_estado.
 */
@Entity
@Table(name = "gan_desct_variable", schema = "rrhh")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GanDescVariable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "fec_movim", nullable = false)
    private LocalDate fecMovim;

    @Column(name = "concepto_id", nullable = false)
    private Long conceptoId;

    @Column(name = "nro_doc", length = 30)
    private String nroDoc;

    @Column(name = "imp_var", precision = 18, scale = 4)
    private BigDecimal impVar;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "cant_labor", precision = 18, scale = 4)
    private BigDecimal cantLabor;

    @Column(name = "nro_dias", precision = 8, scale = 2)
    private BigDecimal nroDias;

    @Column(name = "nro_horas", precision = 8, scale = 2)
    private BigDecimal nroHoras;

    @Column(name = "nro_cuotas")
    private Integer nroCuotas;

    @Column(name = "tipo_planilla_id")
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
