package com.sigre.almacen.entity;

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
@Table(name = "forma_embarque", schema = "almacen")
public class FormaEmbarque {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "forma_embarque", nullable = false, unique = true, length = 4)
    private String formaEmbarque;

    @Column(name = "descripcion", length = 30)
    private String descripcion;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
