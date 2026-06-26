package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "canal_distribucion", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"codigo"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CanalDistribucion extends BaseEntity {
    
    @Column(name = "codigo", nullable = false, length = 20, unique = true)
    private String codigo;
    
    @Column(name = "nombre", nullable = false, length = 120)
    private String nombre;
}
