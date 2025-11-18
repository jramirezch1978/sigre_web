package com.sigre.seguridad.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entidad Permiso - Tabla PERMISO de Oracle
 */
@Entity
@Table(name = "PERMISO")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Permiso {

    @Id
    @Column(name = "COD_PERMISO", length = 50)
    private String codPermiso;

    @Column(name = "NOM_PERMISO", length = 100, nullable = false)
    private String nomPermiso;

    @Column(name = "DESCRIPCION", length = 500)
    private String descripcion;

    @Column(name = "MODULO", length = 50)
    private String modulo;

    @Column(name = "ACCION", length = 20)
    private String accion; // READ, WRITE, DELETE, UPDATE
}

