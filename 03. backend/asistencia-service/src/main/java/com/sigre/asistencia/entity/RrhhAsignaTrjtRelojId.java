package com.sigre.asistencia.entity;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class RrhhAsignaTrjtRelojId implements Serializable {
    
    private String codTrabajador;
    private String codTarjeta;
}