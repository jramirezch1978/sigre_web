package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "articulo_precio_pactado", schema = "compras")
public class ArticuloPrecioPactado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "proveedor_id", nullable = false)
    private Long proveedorId;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal precio;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "fecha_desde")
    private LocalDate fechaDesde;

    @Column(name = "fecha_hasta")
    private LocalDate fechaHasta;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
