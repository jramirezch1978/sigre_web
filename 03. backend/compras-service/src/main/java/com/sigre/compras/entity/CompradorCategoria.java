package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "comprador_categoria", schema = "compras")
public class CompradorCategoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "comprador_id", nullable = false)
    private Long compradorId;

    @Column(name = "articulo_categ_id", nullable = false)
    private Long articuloCategId;
}
