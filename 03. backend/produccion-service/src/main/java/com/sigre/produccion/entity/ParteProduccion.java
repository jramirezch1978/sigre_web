package com.sigre.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "parte_produccion", schema = "produccion")
public class ParteProduccion extends BaseEntity {

    @Column(name = "orden_trabajo_id", nullable = false)
    private Long ordenTrabajoId;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "turno_id")
    private Long turnoId;
}
