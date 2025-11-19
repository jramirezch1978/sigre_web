package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Entity
@Table(name = "origen")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Origen {

    @Id
    @Column(name = "COD_ORIGEN", length = 2)
    private String codOrigen;

    @Column(name = "NOMBRE", length = 30)
    private String nombre;

    @Column(name = "DIR_CALLE", length = 100)
    private String dirCalle;

    @Column(name = "DIR_DISTRITO", length = 30)
    private String dirDistrito;

    @Column(name = "DIR_DEPARTAMENTO", length = 30)
    private String dirDepartamento;

    @Column(name = "DIR_PROVINCIA", length = 30)
    private String dirProvincia;

    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";

    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}

