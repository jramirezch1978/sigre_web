package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "sunat_cubso", schema = "core")
public class SunatCubso extends BaseEntity {

    @Column(name = "cod_cubso", nullable = false, unique = true, length = 20)
    private String codCubso;

    @Column(name = "descripcion", nullable = false, length = 500)
    private String descripcion;

    @Column(name = "cod_clase", length = 20)
    private String codClase;
}
