package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "pedido_mesa_det", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PedidoMesaDet extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pedido_mesa_id", nullable = false)
    private PedidoMesa pedidoMesa;
    
    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;
    
    @Column(name = "cantidad", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;
    
    @Column(name = "precio_unitario", nullable = false, precision = 18, scale = 6)
    private BigDecimal precioUnitario;
    
    @Column(name = "subtotal", nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal;
    
    @Column(name = "observacion", length = 250)
    private String observacion;
    
    // Clases internas para FKs
    @Entity
    @Table(name = "articulo", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Articulo {
        @Id
        private Long id;
        
        @Column(name = "nombre")
        private String nombre;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
}
