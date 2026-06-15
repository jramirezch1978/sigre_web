package com.sigre.contabilidad.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "grupo_matriz_cntbl", schema = "contabilidad")
public class GrupoMatrizCntbl extends BaseEntity {

    @Column(nullable = false, unique = true, length = 6)
    private String codigo;

    @Column(nullable = false, length = 120)
    private String nombre;
}
