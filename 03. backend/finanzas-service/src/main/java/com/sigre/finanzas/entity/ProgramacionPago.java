package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "programacion_pago", schema = "finanzas")
public class ProgramacionPago extends BaseEntity {

    @Column(name = "fecha_programada", nullable = false)
    private LocalDate fechaProgramada;


    @OneToMany(mappedBy = "programacionPago", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProgramacionPagoDet> detalles = new ArrayList<>();

    public void addDetalle(ProgramacionPagoDet detalle) {
        detalles.add(detalle);
        detalle.setProgramacionPago(this);
    }

    public void removeDetalle(ProgramacionPagoDet detalle) {
        detalles.remove(detalle);
        detalle.setProgramacionPago(null);
    }

    public void clearDetalles() {
        detalles.forEach(detalle -> detalle.setProgramacionPago(null));
        detalles.clear();
    }
}
