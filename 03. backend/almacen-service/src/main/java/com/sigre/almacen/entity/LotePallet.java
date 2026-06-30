package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "lote_pallet",
        schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"articulo_id", "nro_lote"}))
public class LotePallet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "articulo_id", nullable = false)
    private Long articuloId;

    @Column(name = "nro_lote", nullable = false, length = 40)
    private String nroLote;

    @Column(name = "fecha_produccion")
    private LocalDate fechaProduccion;

    @Column(name = "fecha_vencimiento")
    private LocalDate fechaVencimiento;

    @Column(name = "observacion", length = 1000)
    private String observacion;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
