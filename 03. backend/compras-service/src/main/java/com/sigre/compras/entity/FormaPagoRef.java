package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "forma_pago", schema = "core")
public class FormaPagoRef {

    @Id
    private Long id;

    @Column(length = 20)
    private String codigo;

    @Column(length = 120)
    private String nombre;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
