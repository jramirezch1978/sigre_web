package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "entidad_banco_cnta", schema = "core")
public class EntidadBancoCntaRef {

    @Id
    private Long id;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "cod_banco", length = 3)
    private String codBanco;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "nro_cuenta", length = 60)
    private String nroCuenta;

    @Column(length = 60)
    private String cci;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
