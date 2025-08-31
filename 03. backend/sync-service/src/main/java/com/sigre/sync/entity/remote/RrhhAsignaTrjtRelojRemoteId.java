package com.sigre.sync.entity.remote;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class RrhhAsignaTrjtRelojRemoteId implements Serializable {
    
    private String codTrabajador;
    private String codTarjeta;
}
