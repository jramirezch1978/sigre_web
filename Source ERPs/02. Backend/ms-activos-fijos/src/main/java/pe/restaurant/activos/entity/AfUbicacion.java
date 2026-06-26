package pe.restaurant.activos.entity;

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
@Table(name = "af_ubicacion", schema = "activos",
        uniqueConstraints = @UniqueConstraint(columnNames = {"sucursal_id", "codigo"}))
public class AfUbicacion extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(nullable = false, length = 20)
    private String codigo;

    @Column(nullable = false, length = 150)
    private String nombre;
}
