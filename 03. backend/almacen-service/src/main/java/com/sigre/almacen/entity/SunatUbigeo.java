package com.sigre.almacen.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Ubigeo SUNAT (departamento/provincia/distrito de Perú). Solo lectura para poblar selects. */
@Getter
@Setter
@Entity
@Table(name = "sunat_ubigeo", schema = "core")
public class SunatUbigeo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ubigeo", length = 6)
    private String ubigeo;

    @Column(name = "distrito", length = 200)
    private String distrito;

    @Column(name = "provincia", length = 200)
    private String provincia;

    @Column(name = "departamento", length = 200)
    private String departamento;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
