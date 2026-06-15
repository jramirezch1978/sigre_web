package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "sucursal", schema = "auth")
public class SucursalRef {

    @Id
    private Long id;

    @Column(length = 2)
    private String codigo;

    @Column(length = 150)
    private String nombre;

    @Column(length = 300)
    private String direccion;
}
