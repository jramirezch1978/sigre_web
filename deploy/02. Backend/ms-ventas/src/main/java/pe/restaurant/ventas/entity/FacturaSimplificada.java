package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "fs_factura_simpl", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificada extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;
    
    @Column(name = "punto_venta_id")
    private Long puntoVentaId;
    
    @Column(name = "cliente_id", nullable = false)
    private Long clienteId;
    
    @Column(name = "doc_tipo_id", nullable = false)
    private Long docTipoId;
    
    @Column(name = "serie", nullable = false, length = 10)
    private String serie;
    
    @Column(name = "numero", nullable = false, length = 20)
    private String numero;
    
    @Column(name = "fecha_emision", nullable = false)
    private LocalDate fechaEmision;
    
    @Column(name = "moneda_id")
    private Long monedaId;
    
    @Column(name = "subtotal", nullable = false, precision = 18, scale = 4)
    private BigDecimal subtotal;
    
    @Column(name = "impuesto", nullable = false, precision = 18, scale = 4)
    private BigDecimal impuesto;
    
    @Column(name = "total", nullable = false, precision = 18, scale = 4)
    private BigDecimal total;
    
    // Relaciones
    @OneToMany(mappedBy = "facturaSimplificada", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private java.util.List<FacturaSimplificadaDet> items;
    
    @OneToMany(mappedBy = "facturaSimplificada", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private java.util.List<FacturaSimplificadaPagos> pagos;
    
    // Clases internas para FKs
    @Entity
    @Table(name = "sucursal", schema = "auth")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Sucursal {
        @Id
        private Long id;
        
        @Column(name = "nombre")
        private String nombre;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
    
    @Entity
    @Table(name = "punto_venta", schema = "ventas")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PuntoVenta {
        @Id
        private Long id;
        
        @Column(name = "codigo")
        private String codigo;
        
        @Column(name = "nombre")
        private String nombre;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
    
    @Entity
    @Table(name = "entidad_contribuyente", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EntidadContribuyente {
        @Id
        private Long id;
        
        @Column(name = "razon_social")
        private String razonSocial;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
    
    @Entity
    @Table(name = "doc_tipo", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DocTipo {
        @Id
        private Long id;
        
        @Column(name = "nombre")
        private String nombre;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
    
    @Entity
    @Table(name = "moneda", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Moneda {
        @Id
        private Long id;
        
        @Column(name = "simbolo")
        private String simbolo;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
}
