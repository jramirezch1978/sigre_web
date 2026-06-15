package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter @Setter @NoArgsConstructor
@Entity @Table(name = "asignacion_os_oc", schema = "compras")
public class AsignacionOsOc {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "orden_servicio_id", nullable = false)
    private Long ordenServicioId;
    @Column(name = "orden_compra_id", nullable = false)
    private Long ordenCompraId;
    @Column(name = "fecha_asignacion")
    private OffsetDateTime fechaAsignacion;
    @Column(name = "created_by")
    private Long createdBy;
    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;
    @OneToMany(mappedBy = "asignacionOsOc", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AsignacionOsOcDet> detalles = new ArrayList<>();
    @PrePersist
    void prePersist() { fecCreacion = OffsetDateTime.now(); if (fechaAsignacion == null) fechaAsignacion = OffsetDateTime.now(); }
}
