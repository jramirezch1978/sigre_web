package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "carta_det", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartaDet extends BaseEntity {
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "carta_id", nullable = false)
    private Carta carta;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "articulo_id", nullable = false)
    private Articulo articulo;
    
    @Column(name = "precio", precision = 18, scale = 4)
    private BigDecimal precio;
    
    @Column(name = "orden")
    private Integer orden;
    
    // Clase interna para Articulo (para evitar dependencias circulares)
    @Entity
    @Table(name = "articulo", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Articulo {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        
        @Column(name = "codigo", nullable = false, length = 20)
        private String codigo;
        
        @Column(name = "nombre", nullable = false, length = 200)
        private String nombre;
        
                
        @Column(name = "flag_estado", nullable = false, length = 1)
        private String flagEstado;
    }
}
