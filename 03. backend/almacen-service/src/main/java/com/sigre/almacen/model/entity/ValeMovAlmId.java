package com.sigre.almacen.model.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.io.Serializable;

@Embeddable
@Data
public class ValeMovAlmId implements Serializable {

    @Column(name = "EMPRESA", length = 10)
    private String empresa;

    @Column(name = "NRO_VALE", length = 20)
    private String nroVale;
}

