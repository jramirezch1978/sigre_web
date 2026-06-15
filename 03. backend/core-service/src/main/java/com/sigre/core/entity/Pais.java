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
@Table(name = "pais", schema = "core")
public class Pais extends BaseEntity {

    @Column(nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "formato_fecha", length = 20)
    private String formatoFecha;

    @Column(name = "zona_horaria", length = 60)
    private String zonaHoraria;
}
