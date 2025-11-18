package com.sigre.contabilidad.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Clave compuesta para PlanCuentas
 */
@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PlanCuentasId implements Serializable {

    @Column(name = "EMPRESA", length = 10)
    private String empresa;

    @Column(name = "CNTA_CNTBL", length = 20)
    private String cntaCntbl;
}

