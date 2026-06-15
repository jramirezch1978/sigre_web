package com.sigre.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "asistencia", schema = "rrhh")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Asistencia extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "hora_entrada")
    private LocalTime horaEntrada;

    @Column(name = "hora_salida")
    private LocalTime horaSalida;

    @Column(name = "tipo_mov_asistencia_id")
    private Long tipoMovAsistenciaId;

    @Column(name = "horas_trabajadas", precision = 8, scale = 2)
    private BigDecimal horasTrabajadas;

    @Column(name = "horas_extra", precision = 8, scale = 2)
    private BigDecimal horasExtra;
}
