package com.sigre.asistencia.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Clave primaria compuesta para NumDocTipo
 * PK: tipo_doc + cod_origen
 */
@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NumDocTipoId implements Serializable {
    
    @Column(name = "tipo_doc", length = 20)
    private String tipoDoc;
    
    @Column(name = "cod_origen", length = 2)
    private String codOrigen;
}
