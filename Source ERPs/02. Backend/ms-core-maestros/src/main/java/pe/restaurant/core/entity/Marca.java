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
@Table(name = "marca", schema = "core")
public class Marca extends BaseEntity {

    @Column(nullable = false, length = 20)
    private String codigo;

    @Column(nullable = false, length = 120)
    private String nombre;
}
