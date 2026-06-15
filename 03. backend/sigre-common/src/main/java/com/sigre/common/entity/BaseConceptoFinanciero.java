package com.sigre.common.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@MappedSuperclass
public abstract class BaseConceptoFinanciero extends BaseEntity {

    @Column(nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String nombre;

    @Column(name = "matriz_contable_id", nullable = false)
    private Long matrizContableId;

    @Column(name = "grupo_concepto_financiero_id")
    private Long grupoConceptoFinancieroId;
}
