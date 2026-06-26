package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalTime;

@Entity
@Table(name = "turno", schema = "rrhh")
@Getter
@Setter
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class Turno extends BaseEntity {
    @Column(nullable = false, length = 120)
    private String nombre;

    @Column(name = "hora_entrada")
    private LocalTime horaEntrada;

    @Column(name = "hora_salida")
    private LocalTime horaSalida;

    @Column(name = "minutos_tolerancia", nullable = false)
    private Integer minutosTolerancia = 0;

    @Column(name = "aplica_lunes", nullable = false)
    private Boolean aplicaLunes = true;

    @Column(name = "aplica_martes", nullable = false)
    private Boolean aplicaMartes = true;

    @Column(name = "aplica_miercoles", nullable = false)
    private Boolean aplicaMiercoles = true;

    @Column(name = "aplica_jueves", nullable = false)
    private Boolean aplicaJueves = true;

    @Column(name = "aplica_viernes", nullable = false)
    private Boolean aplicaViernes = true;

    @Column(name = "aplica_sabado", nullable = false)
    private Boolean aplicaSabado = false;

    @Column(name = "aplica_domingo", nullable = false)
    private Boolean aplicaDomingo = false;
}
