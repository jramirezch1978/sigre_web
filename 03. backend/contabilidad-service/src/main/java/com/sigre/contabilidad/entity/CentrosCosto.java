package com.sigre.contabilidad.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "centros_costo", schema = "contabilidad")
public class CentrosCosto extends BaseEntity {

    @Column(name = "cencos_niv3_id")
    private Long cencosNiv3Id;

    @Column(nullable = false, unique = true, length = 30)
    private String cencos;

    @Column(name = "desc_cencos", nullable = false, length = 200)
    private String descCencos;
}
