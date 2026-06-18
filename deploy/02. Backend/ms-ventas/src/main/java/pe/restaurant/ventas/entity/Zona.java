package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "zona", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"sucursal_id", "nombre"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Zona extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sucursal_id", nullable = false)
    private Sucursal sucursal;
    
    @Column(name = "nombre", nullable = false, length = 120)
    private String nombre;
    
    @Column(name = "capacidad")
    private Integer capacidad;
    
    // Clase interna para Sucursal (para evitar dependencias circulares)
    @Entity
    @Table(name = "sucursal", schema = "auth")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Sucursal extends BaseEntity {
        @Column(name = "codigo", nullable = false, length = 2)
        private String codigo;
        
        @Column(name = "nombre", nullable = false, length = 150)
        private String nombre;
    }
}
