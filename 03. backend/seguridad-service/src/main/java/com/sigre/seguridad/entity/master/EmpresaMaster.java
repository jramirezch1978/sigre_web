package com.sigre.seguridad.entity.master;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.Instant;

/**
 * Registro de empresa en la BD de seguridad (schema master).
 */
@Entity
@Table(name = "empresa", schema = "master")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmpresaMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(nullable = false, unique = true, length = 20)
    private String ruc;

    @Column(name = "razon_social", nullable = false, length = 200)
    private String razonSocial;

    @Column(name = "nombre_comercial", length = 200)
    private String nombreComercial;

    @Column(name = "direccion_fiscal", length = 300)
    private String direccionFiscal;

    @Column(length = 12)
    private String ubigeo;

    @Column(name = "representante_legal", length = 200)
    private String representanteLegal;

    @Column(name = "correo_contacto", length = 150)
    private String correoContacto;

    @Column(name = "telefono_contacto", length = 30)
    private String telefonoContacto;

    @Column(name = "db_host", nullable = false, length = 120)
    private String dbHost;

    @Column(name = "db_port", nullable = false)
    private Integer dbPort;

    @Column(name = "db_name", nullable = false, length = 120)
    private String dbName;

    @Column(name = "db_user", nullable = false, length = 120)
    private String dbUser;

    @Column(name = "db_password_encrypted", nullable = false, columnDefinition = "TEXT")
    private String dbPasswordEncrypted;

    /**
     * BYTEA en PostgreSQL. No usar {@code @Lob}: Hibernate puede enviar OID (bigint) en lugar de bytes.
     */
    @JdbcTypeCode(SqlTypes.VARBINARY)
    @Column(name = "logo", columnDefinition = "BYTEA")
    private byte[] logo;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado;

    @Column(name = "modificado_en")
    private Instant modificadoEn;

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
