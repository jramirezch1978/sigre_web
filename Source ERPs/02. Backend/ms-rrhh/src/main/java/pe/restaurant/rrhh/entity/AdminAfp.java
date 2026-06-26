package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

/**
 * Entidad que representa una Administradora de Fondos de Pensiones (AFP).
 * 
 * <p>Almacena información sobre las AFP del sistema peruano, incluyendo
 * los porcentajes de comisión, prima de seguro y aporte obligatorio
 * que se aplican a los colaboradores.</p>
 * 
 * @author Sistema de RRHH
 * @version 1.0
 */
@Entity
@Table(name = "admin_afp", schema = "rrhh")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class AdminAfp extends BaseEntity {
    
    /**
     * Nombre de la AFP.
     * Obligatorio y único en el sistema.
     */
    @Column(nullable = false, length = 120)
    private String nombre;
    
    /**
     * Porcentaje de comisión sobre la remuneración.
     * Valor opcional, debe ser >= 0 si se informa.
     */
    @Column(name = "comision_porcentaje", precision = 8, scale = 4)
    private BigDecimal comisionPorcentaje;
    
    /**
     * Porcentaje de prima de seguro.
     * Valor opcional, debe ser >= 0 si se informa.
     */
    @Column(name = "prima_seguro", precision = 8, scale = 4)
    private BigDecimal primaSeguro;
    
    /**
     * Porcentaje de aporte obligatorio al fondo.
     * Valor opcional, debe ser >= 0 si se informa.
     */
    @Column(name = "aporte_obligatorio", precision = 8, scale = 4)
    private BigDecimal aporteObligatorio;
}
