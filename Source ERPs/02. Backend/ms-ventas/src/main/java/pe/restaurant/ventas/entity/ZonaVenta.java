package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "vta_zona_venta", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"zona_venta"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaVenta extends BaseEntity {
    
    @Column(name = "zona_venta", nullable = false, length = 8, unique = true)
    private String zonaVenta;
    
    @Column(name = "desc_zona_venta", nullable = false, length = 200)
    private String descZonaVenta;
    
    @Column(name = "ubigeo", columnDefinition = "CHAR(6)")
    private String ubigeo;
}
