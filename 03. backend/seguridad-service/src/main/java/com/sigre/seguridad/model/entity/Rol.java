package com.sigre.seguridad.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

/**
 * Entidad Rol - Tabla ROL de Oracle
 */
@Entity
@Table(name = "ROL")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Rol {

    @Id
    @Column(name = "COD_ROL", length = 20)
    private String codRol;

    @Column(name = "NOM_ROL", length = 100, nullable = false)
    private String nomRol;

    @Column(name = "DESCRIPCION", length = 500)
    private String descripcion;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "ROL_PERMISO",
        joinColumns = @JoinColumn(name = "COD_ROL"),
        inverseJoinColumns = @JoinColumn(name = "COD_PERMISO")
    )
    private Set<Permiso> permisos;
}

