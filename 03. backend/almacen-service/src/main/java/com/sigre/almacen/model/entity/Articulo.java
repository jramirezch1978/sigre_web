package com.sigre.almacen.model.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;

@Entity
@Table(name = "ARTICULO")
@Data
public class Articulo {

    @Id
    @Column(name = "COD_ART", length = 20)
    private String codArt;

    @Column(name = "DESCRIPCION", length = 200)
    private String descripcion;

    @Column(name = "UNIDAD", length = 10)
    private String unidad;

    @Column(name = "TIPO_ARTICULO", length = 10)
    private String tipoArticulo;

    @Column(name = "PRECIO_PROMEDIO", precision = 18, scale = 4)
    private BigDecimal precioPromedio;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado;
}

