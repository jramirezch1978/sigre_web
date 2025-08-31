package com.sigre.sync.entity.local;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class RrhhAsignaTrjtRelojLocalId implements Serializable {
    
    private String codTrabajador;
    private String codTarjeta;
}
