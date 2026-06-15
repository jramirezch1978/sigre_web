package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "ubicacion_almacen", schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"almacen_id", "codigo"}))
public class UbicacionAlmacen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "codigo", nullable = false, length = 20)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 120)
    private String nombre;

    @Column(name = "pasillo", length = 30)
    private String pasillo;

    @Column(name = "estante", length = 30)
    private String estante;

    @Column(name = "nivel", length = 30)
    private String nivel;
}
