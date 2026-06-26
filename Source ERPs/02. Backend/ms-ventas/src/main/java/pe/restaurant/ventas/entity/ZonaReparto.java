package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "vta_zona_reparto", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"zona_reparto"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaReparto extends BaseEntity {
    
    @Column(name = "zona_reparto", nullable = false, length = 8, unique = true)
    private String zonaReparto;
    
    @Column(name = "desc_zona_reparto", nullable = false, length = 200)
    private String descZonaReparto;
    
    @Column(name = "ubigeo", columnDefinition = "CHAR(6)")
    private String ubigeo;
}
