package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "mesa", schema = "ventas",
       uniqueConstraints = @UniqueConstraint(columnNames = {"numero"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Mesa extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "zona_id", nullable = false)
    private Zona zona;
    
    @Column(name = "numero", nullable = false, length = 20, unique = true)
    private String numero;
    
    @Column(name = "capacidad")
    private Integer capacidad;
    
    // Clase interna para Zona (para evitar dependencias circulares)
    @Entity
    @Table(name = "zona", schema = "ventas")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Zona extends BaseEntity {
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "sucursal_id")
        private Sucursal sucursal;
        
        @Column(name = "nombre", nullable = false, length = 120)
        private String nombre;
        
        @Column(name = "capacidad")
        private Integer capacidad;
        
        // Clase interna para Sucursal
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
}
