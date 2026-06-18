package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tipo_novedad_rrhh", schema = "rrhh",
    uniqueConstraints = {
        @UniqueConstraint(name = "UK_TIPO_NOVEDAD_RRHH_CODIGO", columnNames = "codigo")
    }
)
public class TipoNovedadRrhh extends BaseEntity {

    @Column(name = "codigo", nullable = false, unique = true, length = 20)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 120)
    private String nombre;
}
