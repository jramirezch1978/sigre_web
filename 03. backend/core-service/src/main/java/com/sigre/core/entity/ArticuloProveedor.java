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
@Table(name = "entidad_articulo", schema = "compras")
public class ArticuloProveedor extends BaseEntity {

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "entidad_contribuyente_id", nullable = false)
    private Long proveedorId;
}
