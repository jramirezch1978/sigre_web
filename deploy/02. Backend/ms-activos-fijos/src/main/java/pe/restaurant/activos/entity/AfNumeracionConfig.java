package pe.restaurant.activos.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
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
@Table(
        name = "af_numeracion_config",
        schema = "activos",
        uniqueConstraints = @UniqueConstraint(name = "uq_af_numeracion_config_tipo", columnNames = "tipo"))
public class AfNumeracionConfig extends BaseEntity {

    @Column(nullable = false, length = 20)
    private String tipo;

    @Column(nullable = false, length = 20)
    private String prefijo = "AF";

    @Column(name = "secuencia_actual", nullable = false)
    private Long secuenciaActual = 0L;

    @Column(name = "longitud_numero", nullable = false)
    private Integer longitudNumero = 6;
}
