package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "fs_factura_simpl_pagos", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = "factura")
public class FsFacturaSimplPago extends BaseEntity {

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "fs_factura_simpl_id", nullable = false)
    private FsFacturaSimpl factura;

    @Column(name = "forma_pago_id")
    private Long formaPagoId;

    @Column(name = "monto", nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(name = "referencia", length = 120)
    private String referencia;

    @Column(name = "fecha_pago", nullable = false)
    private Instant fechaPago = Instant.now();
}
