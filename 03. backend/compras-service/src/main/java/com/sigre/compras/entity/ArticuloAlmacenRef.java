package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "articulo_almacen", schema = "almacen")
public class ArticuloAlmacenRef {

    @Id
    private Long id;

    @Column(name = "articulo_id")
    private Long articuloId;

    @Column(name = "almacen_id")
    private Long almacenId;

    @Column(name = "cantidad_disponible", precision = 18, scale = 4)
    private BigDecimal cantidadDisponible;
}
