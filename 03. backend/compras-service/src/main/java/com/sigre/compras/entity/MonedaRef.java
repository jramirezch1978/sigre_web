package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "moneda", schema = "core")
public class MonedaRef {

    @Id
    private Long id;

    @Column(length = 10)
    private String codigo;

    @Column(length = 80)
    private String nombre;

    @Column(length = 10)
    private String simbolo;

    public String getSimbolo() {
        if (simbolo != null && !simbolo.isBlank()) return simbolo;
        return codigo != null ? codigo : "";
    }
}
