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
@Table(name = "af_sub_clase", schema = "activos",
        uniqueConstraints = @UniqueConstraint(columnNames = {"af_clase_id", "codigo"}))
public class AfSubClase extends BaseEntity {

    @Column(name = "af_clase_id", nullable = false)
    private Long afClaseId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "af_clase_id", nullable = false, insertable = false, updatable = false)
    private AfClase afClase;

    @Column(nullable = false, length = 20)
    private String codigo;

    @Column(nullable = false, length = 120)
    private String nombre;

    @Column(name = "vida_util_meses")
    private Integer vidaUtilMeses;
}
