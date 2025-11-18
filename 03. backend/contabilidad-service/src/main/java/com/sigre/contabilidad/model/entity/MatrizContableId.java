package com.sigre.contabilidad.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * Clave compuesta para MatrizContable
 */
@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class MatrizContableId implements Serializable {

    @Column(name = "EMPRESA", length = 10)
    private String empresa;

    @Column(name = "MODULO", length = 20)
    private String modulo; // ALM, VEN, COM, RRHH, PROD

    @Column(name = "TIPO_MOVIMIENTO", length = 20)
    private String tipoMovimiento; // INGRESO, SALIDA, VENTA, COMPRA, etc.

    @Column(name = "TIPO_ARTICULO", length = 20)
    private String tipoArticulo; // PT=Producto Terminado, MP=Materia Prima, etc.

    @Column(name = "SECUENCIA")
    private Integer secuencia; // Para múltiples asientos del mismo movimiento
}

