package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "fs_factura_simpl_det", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificadaDet extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fs_factura_simpl_id", nullable = false)
    private FacturaSimplificada facturaSimplificada;
    
    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;
    
    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;
    
    @Column(name = "cantidad", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidad;
    
    @Column(name = "precio_unitario", nullable = false, precision = 18, scale = 6)
    private BigDecimal precioUnitario;
    
    @Column(name = "subtotal", nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal;
    
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
    
    @Entity
    @Table(name = "unidad_medida", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UnidadMedida {
        @Id
        private Long id;
        
        @Column(name = "nombre")
        private String nombre;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
}
