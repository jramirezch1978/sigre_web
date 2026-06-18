package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

/**
 * Entidad que representa un concepto de planilla.
 * Los conceptos pueden ser de tipo INGRESO, DESCUENTO o APORTE y se utilizan
 * para el cálculo automático de la planilla de remuneraciones.
 * Extiende de BaseEntity para heredar campos de auditoría y flag_estado.
 * 
 * @author Equipo de Desarrollo RRHH
 */
@Getter
@Setter
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "concepto_planilla", schema = "rrhh",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_CONCEPTO_PLANILLA_CODIGO", columnNames = "codigo")
    }
)
public class ConceptoPlanilla extends BaseEntity {

    @Column(name = "codigo", nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "tipo", nullable = false, length = 30)
    private String tipo;

    @Column(name = "formula", columnDefinition = "TEXT")
    private String formula;

    @Column(name = "valor_fijo", precision = 18, scale = 4)
    private BigDecimal valorFijo;

    @Column(name = "afecto_quinta", nullable = false)
    private Boolean afectoQuinta = false;

    @Column(name = "afecto_essalud", nullable = false)
    private Boolean afectoEssalud = false;

    @Column(name = "aplica_todos", nullable = false)
    private Boolean aplicaTodos = true;
}
