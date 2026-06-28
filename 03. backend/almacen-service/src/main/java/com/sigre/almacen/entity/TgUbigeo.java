package com.sigre.almacen.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/** Catálogo TG_UBIGEO (zonas/puertos). Solo lectura para poblar selects. */
@Getter
@Setter
@Entity
@Table(name = "tg_ubigeo", schema = "core")
public class TgUbigeo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "ubigeo_codigo", length = 6)
    private String ubigeoCodigo;

    @Column(name = "ubige_descripcion", length = 20)
    private String ubigeDescripcion;

    @Column(name = "flag_replicacion", length = 1)
    private String flagReplicacion;
}
