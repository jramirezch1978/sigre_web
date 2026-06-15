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
@Table(name = "moneda", schema = "core")
public class Moneda extends BaseEntity {

    @Column(nullable = false, unique = true, length = 10)
    private String codigo;

    @Column(name = "sigla_moneda", length = 10)
    private String siglaMoneda;

    @Column(nullable = false, length = 80)
    private String nombre;

    @Column(length = 10)
    private String simbolo;

    @Column(nullable = false)
    private Integer decimales = 2;
}
