package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "vta_zona_despacho", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"zona_despacho"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaDespacho extends BaseEntity {
    
    @Column(name = "zona_despacho", nullable = false, length = 8, unique = true)
    private String zonaDespacho;
    
    @Column(name = "desc_zona_despacho", nullable = false, length = 200)
    private String descZonaDespacho;
    
    @Column(name = "ubigeo", length = 6)
    private String ubigeo;
}
