package com.sigre.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "sucursal", schema = "auth")
public class Sucursal extends BaseEntity {

    @Column(nullable = false, unique = true, length = 2)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(length = 300)
    private String direccion;

    @Column(length = 120)
    private String ciudad;

    @Column(name = "pais_id")
    private Long paisId;

    @Column(name = "departamento_id")
    private Long departamentoId;

    @Column(name = "provincia_id")
    private Long provinciaId;

    @Column(name = "distrito_id")
    private Long distritoId;

    @Column(length = 12)
    private String ubigeo;
}
