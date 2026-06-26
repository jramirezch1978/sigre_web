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
@Table(name = "art_super_grupo", schema = "core")
public class ArtSuperGrupo extends BaseEntity {

    @Column(nullable = false, length = 20)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String nombre;
}
