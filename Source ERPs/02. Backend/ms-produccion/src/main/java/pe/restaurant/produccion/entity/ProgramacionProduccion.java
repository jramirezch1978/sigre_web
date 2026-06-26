package pe.restaurant.produccion.entity;

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
@Table(name = "programacion_produccion", schema = "produccion")
public class ProgramacionProduccion extends BaseEntity {

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "receta_id", nullable = false)
    private Long recetaId;

    @Column(name = "orden_trabajo_id", nullable = false)
    private Long ordenTrabajoId;

    @Column(name = "flag_frecuencia", nullable = false, length = 1)
    private String flagFrecuencia;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(name = "cantidad_por_periodo", nullable = false, precision = 18, scale = 4)
    private BigDecimal cantidadPorPeriodo;

    @Column(name = "flag_turno", length = 1)
    private String flagTurno;
}
