package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "tipos_impuesto", schema = "core")
public class TiposImpuestoRef {

    @Id
    private Long id;

    @Column(name = "tipo_impuesto", length = 10, nullable = false)
    private String tipoImpuesto;

    @Column(name = "tasa_impuesto", precision = 8, scale = 4, nullable = false)
    private BigDecimal tasaImpuesto;

    @Column(length = 1, nullable = false)
    private String signo;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
