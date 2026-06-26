package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "catalogo_sunat_det", schema = "core")
public class CatalogoSunatDet extends BaseEntity {

    @Column(name = "catalogo_sunat_id", nullable = false)
    private Long catalogoSunatId;

    @Column(name = "codigo_item", nullable = false, length = 30)
    private String codigoItem;

    @Column(name = "nombre_item", nullable = false, length = 500)
    private String nombreItem;

    @Column(name = "descripcion_item", columnDefinition = "TEXT")
    private String descripcionItem;
}
