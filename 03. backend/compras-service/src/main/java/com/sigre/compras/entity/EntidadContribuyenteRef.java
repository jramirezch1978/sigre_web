package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "entidad_contribuyente", schema = "core")
public class EntidadContribuyenteRef {

    @Id
    private Long id;

    @Column(name = "tipo_documento", length = 20)
    private String tipoDocumento;

    @Column(name = "tipo_doc_identidad_id")
    private Long tipoDocIdentidadId;

    @Column(name = "nro_documento", length = 30)
    private String nroDocumento;

    @Column(name = "razon_social", length = 200)
    private String razonSocial;

    @Column(name = "nombre_comercial", length = 300)
    private String nombreComercial;

    @Column(length = 300)
    private String direccion;

    @Column(length = 120)
    private String nombres;

    @Column(length = 120)
    private String apellidos;

    @Column(length = 40)
    private String telefono;

    @Column(length = 150)
    private String email;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;

    public String getNombreCompleto() {
        if (razonSocial != null && !razonSocial.isBlank()) return razonSocial;
        String n = nombres != null ? nombres : "";
        String a = apellidos != null ? apellidos : "";
        return (n + " " + a).trim();
    }

    public String getDocIdentidad() {
        String tipo = tipoDocumento != null ? tipoDocumento : "";
        String nro = nroDocumento != null ? nroDocumento : "";
        if (tipo.isEmpty() && nro.isEmpty()) return "";
        return tipo + ": " + nro;
    }
}
