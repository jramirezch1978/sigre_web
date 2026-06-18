package com.sigre.seguridad.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "usuario", schema = "auth")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 150)
    private String email;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, length = 255)
    private String password;

    @Column(nullable = false, length = 100)
    private String nombres;

    @Column(nullable = false, length = 100)
    private String apellidos;

    @Column(name = "nombre_completo", nullable = false, length = 200)
    private String nombreCompleto;

    @Column(name = "dos_factor_habilitado", nullable = false)
    private Boolean dosFactorHabilitado = false;

    @Column(nullable = false)
    private Boolean bloqueado = false;

    @Column(name = "intentos_fallidos", nullable = false)
    private Integer intentosFallidos = 0;

    @Column(name = "bloqueado_hasta")
    private OffsetDateTime bloqueadoHasta;

    @Column(name = "ultimo_login_en")
    private OffsetDateTime ultimoLoginEn;

    @Column(name = "flag_demo", nullable = false, length = 1)
    private String flagDemo = "0";

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }

    @Column(name = "fec_creacion", updatable = false)
    private OffsetDateTime fecCreacion;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    /** Administración de empresas (security): {@code '1'} activo. */
    @Column(name = "flag_admin_sistema", nullable = false, length = 1)
    private String flagAdminSistema = "0";

    @PrePersist
    protected void onCreate() {
        if (fecCreacion == null) {
            fecCreacion = OffsetDateTime.now();
        }
        fecModificacion = OffsetDateTime.now();
        if (dosFactorHabilitado == null) {
            dosFactorHabilitado = false;
        }
        if (bloqueado == null) {
            bloqueado = false;
        }
        if (nombreCompleto == null) {
            nombreCompleto = nombres + " " + apellidos;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
