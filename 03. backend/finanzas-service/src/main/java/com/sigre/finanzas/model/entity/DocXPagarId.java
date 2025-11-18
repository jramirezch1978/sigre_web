package com.sigre.finanzas.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.io.Serializable;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocXPagarId implements Serializable {

    @Column(name = "EMPRESA", length = 10)
    private String empresa;

    @Column(name = "COD_DOC", length = 20)
    private String codDoc;
}

