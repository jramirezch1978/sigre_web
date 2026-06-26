package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.util.List;

@Entity
@Table(name = "carta", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Carta extends BaseEntity {
    
    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;
    
    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;
    
    @Column(name = "descripcion", columnDefinition = "TEXT")
    private String descripcion;
    
    @OneToMany(mappedBy = "carta", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<CartaDet> detalles;
    
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
