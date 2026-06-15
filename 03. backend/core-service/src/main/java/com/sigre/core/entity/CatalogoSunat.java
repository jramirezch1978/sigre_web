package com.sigre.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "catalogo_sunat", schema = "core")
public class CatalogoSunat extends BaseEntity {

    @Column(name = "codigo_catalogo", nullable = false, unique = true, length = 30)
    private String codigoCatalogo;

    @Column(name = "nombre_catalogo", nullable = false, length = 180)
    private String nombreCatalogo;

    @Column(name = "descripcion_catalogo", columnDefinition = "TEXT")
    private String descripcionCatalogo;
}
