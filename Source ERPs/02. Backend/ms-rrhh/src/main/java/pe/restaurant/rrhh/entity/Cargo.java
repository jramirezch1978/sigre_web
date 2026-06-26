package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

/**
 * Entidad que representa un cargo organizacional con su banda salarial.
 * Define los puestos de trabajo disponibles en la organización y sus rangos de remuneración.
 * Extiende de BaseEntity para heredar campos de auditoría y flag_estado.
 */
@Entity
@Table(name = "cargo", schema = "rrhh")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Cargo extends BaseEntity {
    
    @Column(name = "nombre", nullable = false, length = 120)
    private String nombre;
    
    @Column(name = "nivel", length = 30)
    private String nivel;
    
    @Column(name = "sueldo_minimo", precision = 18, scale = 4)
    private BigDecimal sueldoMinimo;
    
    @Column(name = "sueldo_maximo", precision = 18, scale = 4)
    private BigDecimal sueldoMaximo;
}
