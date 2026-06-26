package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "servicios_cxc", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"cod_servicio"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ServiciosCxC extends BaseEntity {
    
    @Column(name = "cod_servicio", nullable = false, columnDefinition = "CHAR(3)", unique = true)
    private String codServicio;
    
    @Column(name = "desc_servicio", nullable = false, length = 200)
    private String descServicio;
    
    @Column(name = "tarifa", precision = 15, scale = 4)
    private BigDecimal tarifa;
    
    @Column(name = "cod_moneda", columnDefinition = "CHAR(3)")
    private String codMoneda;
    
    @Column(name = "flag_afecto_igv", nullable = false, length = 1)
    private String flagAfectoIgv = "1";
}
