package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Distribución de centros de costo por activo ({@code activos.af_maestro_cc_distrib}).
 * No extiende {@link pe.restaurant.common.entity.BaseEntity}: la tabla usa {@code created_at}, sin {@code flag_estado}.
 */
@Getter
@Setter
@Entity
@Table(name = "af_maestro_cc_distrib", schema = "activos")
public class AfMaestroCcDistrib {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "centro_costo_id", nullable = false)
    private Long centroCostoId;

    @Column(nullable = false, precision = 7, scale = 4)
    private BigDecimal porcentaje;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "created_at", insertable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "updated_at", insertable = false)
    private Instant updatedAt;
}
