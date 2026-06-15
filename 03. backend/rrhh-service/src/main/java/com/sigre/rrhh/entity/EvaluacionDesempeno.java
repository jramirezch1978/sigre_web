package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@EqualsAndHashCode(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "evaluacion_desempeno", schema = "rrhh")
public class EvaluacionDesempeno extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "periodo_anio", nullable = false)
    private Integer periodoAnio;

    @Column(name = "periodo_semestre")
    private Integer periodoSemestre;

    @Column(name = "calificacion", precision = 8, scale = 2)
    private BigDecimal calificacion;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "evaluador_id")
    private Long evaluadorId;

    @Column(name = "fecha_evaluacion")
    private LocalDate fechaEvaluacion;
}
