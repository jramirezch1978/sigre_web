package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalDate;

@Entity
@Table(name = "horario_trabajador", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HorarioTrabajador extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "turno_id", nullable = false)
    private Long turnoId;

    @Column(name = "fecha_desde", nullable = false)
    private LocalDate fechaDesde;

    @Column(name = "fecha_hasta")
    private LocalDate fechaHasta;
}
