package com.sigre.comercializacion.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "fs_factura_simpl_pagos", schema = "ventas")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificadaPagos extends BaseEntity {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fs_factura_simpl_id", nullable = false)
    private FacturaSimplificada facturaSimplificada;
    
    @Column(name = "forma_pago_id")
    private Long formaPagoId;
    
    @Column(name = "monto", nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;
    
    @Column(name = "referencia", length = 120)
    private String referencia;
    
    @Column(name = "fecha_pago", nullable = false)
    private Instant fechaPago;
    
    // Clases internas para FKs
    @Entity
    @Table(name = "forma_pago", schema = "core")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class FormaPago {
        @Id
        private Long id;
        
        @Column(name = "nombre")
        private String nombre;
        
        @Column(name = "flag_estado")
        private String flagEstado;
    }
}
