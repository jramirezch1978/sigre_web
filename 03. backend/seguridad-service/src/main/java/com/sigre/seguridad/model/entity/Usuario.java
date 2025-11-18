package com.sigre.seguridad.model.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Set;

/**
 * Entidad Usuario - Tabla USUARIO de Oracle
 */
@Entity
@Table(name = "USUARIO")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Usuario {

    @Id
    @Column(name = "COD_USER", length = 20)
    private String codUser;

    @Column(name = "NOM_USER", length = 100, nullable = false)
    private String nomUser;

    @Column(name = "PASSWORD", length = 200, nullable = false)
    private String password;

    @Column(name = "EMAIL", length = 100)
    private String email;

    @Column(name = "EMPRESA", length = 10)
    private String empresa;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado; // 1=Activo, 0=Inactivo

    @Column(name = "FECHA_CREACION")
    private LocalDateTime fechaCreacion;

    @Column(name = "FECHA_MODIFICACION")
    private LocalDateTime fechaModificacion;

    @Column(name = "ULTIMO_ACCESO")
    private LocalDateTime ultimoAcceso;

    @Column(name = "INTENTOS_FALLIDOS")
    private Integer intentosFallidos;

    @Column(name = "BLOQUEADO", length = 1)
    private String bloqueado; // S=Sí, N=No

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "USUARIO_ROL",
        joinColumns = @JoinColumn(name = "COD_USER"),
        inverseJoinColumns = @JoinColumn(name = "COD_ROL")
    )
    private Set<Rol> roles;

    public boolean isActivo() {
        return "1".equals(flagEstado) && !"S".equals(bloqueado);
    }
}

