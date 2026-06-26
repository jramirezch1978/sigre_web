package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "motivo_cese", schema = "rrhh")
public class MotivoCese extends BaseEntity {
    @Column(name = "codigo", length = 20, nullable = false, unique = true)
    private String codigo;
    @Column(name = "nombre", length = 200, nullable = false)
    private String nombre;
}
