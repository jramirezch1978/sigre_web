package com.sigre.compras.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "doc_tipo", schema = "core")
public class DocTipoRef {

    @Id
    private Long id;

    @Column(length = 10)
    private String codigo;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado;
}
