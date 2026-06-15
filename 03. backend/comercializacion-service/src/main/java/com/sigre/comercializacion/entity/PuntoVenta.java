package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

@Entity
@Table(name = "punto_venta", schema = "ventas", 
       uniqueConstraints = @UniqueConstraint(columnNames = {"sucursal_id", "codigo"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PuntoVenta extends BaseEntity {
    
    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;
    
    @Column(name = "almacen_id")
    private Long almacenId;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sucursal_id", nullable = false, insertable = false, updatable = false)
    private Sucursal sucursal;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "almacen_id", insertable = false, updatable = false)
    private Almacen almacen;
    
    @Column(name = "codigo", nullable = false, length = 20)
    private String codigo;
    
    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;
    
    @Column(name = "serie_boleta", length = 10)
    private String serieBoleta;
    
    @Column(name = "serie_factura", length = 10)
    private String serieFactura;
    
    @Column(name = "tipo_impresora", length = 30)
    private String tipoImpresora;
    
    // Clases internas para las FKs (para evitar dependencias circulares)
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
    
    @Entity
    @Table(name = "almacen", schema = "almacen")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Almacen extends BaseEntity {
        @Column(name = "codigo", nullable = false, length = 20)
        private String codigo;
        
        @Column(name = "nombre", nullable = false, length = 150)
        private String nombre;
    }
}
