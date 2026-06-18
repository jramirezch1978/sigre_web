package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Cabecera de cálculo de planilla para un período (año/mes) y tipo.
 * No extiende BaseEntity ya que la tabla no posee columna flag_estado.
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

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "tipo_planilla_id", nullable = false)
    private Long tipoPlanillaId;

    @Column(name = "total_ingresos", precision = 18, scale = 4)
    private BigDecimal totalIngresos;

    @Column(name = "total_descuentos", precision = 18, scale = 4)
    private BigDecimal totalDescuentos;

    @Column(name = "total_neto", precision = 18, scale = 4)
    private BigDecimal totalNeto;

    @Column(name = "total_aportes", precision = 18, scale = 4)
    private BigDecimal totalAportes;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
