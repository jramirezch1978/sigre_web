package com.sigre.contabilidad.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Clave compuesta para AsientoContable
 */
@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoContableId implements Serializable {

    @Column(name = "EMPRESA", length = 10)
    private String empresa;

    @Column(name = "LIBRO", length = 10)
    private String libro; // DIARIO, COMPRAS, VENTAS, etc.

    @Column(name = "ORIGEN", length = 10)
    private String origen; // VEN, ALM, RRHH, etc.

    @Column(name = "PERIODO", length = 6)
    private String periodo; // YYYYMM

    @Column(name = "NRO_ASIENTO")
    private Long nroAsiento;

    @Column(name = "LINEA")
    private Long linea;

    @Column(name = "CNTA_CNTBL", length = 20)
    private String cntaCntbl;
}

