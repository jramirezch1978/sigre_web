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
@Table(name = "contacto", schema = "core")
public class Contacto extends BaseEntity {

    @ManyToOne(optional = false)
    @JoinColumn(name = "entidad_contribuyente_id")
    private RelacionComercial relacionComercial;

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "cargo", length = 120)
    private String cargo;

    @Column(name = "telefono", length = 40)
    private String telefono;

    @Column(name = "email", length = 150)
    private String email;
}
