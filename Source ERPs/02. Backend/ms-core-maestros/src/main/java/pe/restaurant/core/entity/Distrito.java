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
@Table(name = "distrito", schema = "core")
public class Distrito extends BaseEntity {

    @Column(name = "provincia_id")
    private Long provinciaId;

    @Column(nullable = false, length = 20)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String nombre;
}
