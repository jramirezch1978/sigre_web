package pe.restaurant.activos.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "af_revaluacion", schema = "activos")
public class AfRevaluacion extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(name = "valor_anterior", precision = 18, scale = 4)
    private BigDecimal valorAnterior;

    @Column(name = "valor_nuevo", precision = 18, scale = 4)
    private BigDecimal valorNuevo;

    @Column(columnDefinition = "TEXT")
    private String sustento;

    @Column(name = "perito_id")
    private Long peritoId;
}
