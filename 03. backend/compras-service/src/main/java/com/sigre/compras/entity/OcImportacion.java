package com.sigre.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "oc_importacion", schema = "compras")
public class OcImportacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "orden_compra_id", nullable = false, unique = true)
    private Long ordenCompraId;

    @Column(length = 10)
    private String incoterm;

    @Column(name = "puerto_embarque", length = 100)
    private String puertoEmbarque;

    @Column(name = "puerto_destino", length = 100)
    private String puertoDestino;

    @Column(name = "agente_aduanas", length = 150)
    private String agenteAduanas;

    @Column(name = "nro_dua", length = 30)
    private String nroDua;

    @Column(name = "fecha_embarque")
    private LocalDate fechaEmbarque;

    @Column(name = "fecha_llegada_est")
    private LocalDate fechaLlegadaEst;

    @Column(columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
