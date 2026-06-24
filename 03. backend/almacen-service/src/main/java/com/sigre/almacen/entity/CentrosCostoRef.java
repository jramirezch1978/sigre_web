package com.sigre.almacen.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "centros_costo", schema = "contabilidad")
public class CentrosCostoRef {

    @Id
    private Long id;

    @Column(name = "cencos", length = 30)
    private String cencos;

    @Column(name = "desc_cencos", length = 200)
    private String descCencos;
}
