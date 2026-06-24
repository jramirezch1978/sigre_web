package com.sigre.almacen.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "almacen", schema = "almacen",
        uniqueConstraints = @UniqueConstraint(columnNames = {"sucursal_id", "codigo"}))
public class Almacen {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "almacen_tipo_id")
    private Long almacenTipoId;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "proveedor_entidad_id")
    private Long proveedorEntidadId;

    @Column(name = "responsable_usuario_id")
    private Long responsableUsuarioId;

    @Column(name = "codigo", nullable = false, length = 20)
    private String codigo;

    @Column(name = "nombre", nullable = false, length = 150)
    private String nombre;

    @Column(name = "direccion", length = 80)
    private String direccion;

    @Column(name = "area_total", precision = 7, scale = 2)
    private BigDecimal areaTotal;

    @Column(name = "vol_total", precision = 7, scale = 2)
    private BigDecimal volTotal;

    @Column(name = "corr_guia")
    private Long corrGuia;

    @Column(name = "cod_origen", length = 2)
    private String codOrigen;

    @Column(name = "flag_cntrl_lote", length = 1)
    private String flagCntrlLote = "1";

    @Column(name = "flag_replicacion", length = 1)
    private String flagReplicacion = "1";

    @Column(name = "distrito", length = 25)
    private String distrito;

    @Column(name = "provincia", length = 25)
    private String provincia;

    @Column(name = "departamento", length = 25)
    private String departamento;

    @Column(name = "distrito_id")
    private Long distritoId;

    @Column(name = "ano_apertura")
    private Integer anoApertura;

    @Column(name = "cod_sunat", nullable = false, length = 4)
    private String codSunat = "0001";

    @Column(name = "flag_virtual", length = 1)
    private String flagVirtual = "0";

    @Column(name = "ubigeo", length = 6)
    private String ubigeo;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

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
        if (createdBy == null) {
            createdBy = TenantContext.getUsuarioId();
        }
        aplicarDefaults();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
        updatedBy = TenantContext.getUsuarioId();
        aplicarDefaults();
    }

    private void aplicarDefaults() {
        if (codSunat == null || codSunat.isBlank()) {
            codSunat = "0001";
        }
        if (flagCntrlLote == null || flagCntrlLote.isBlank()) {
            flagCntrlLote = "1";
        }
        if (flagReplicacion == null || flagReplicacion.isBlank()) {
            flagReplicacion = "1";
        }
        if (flagVirtual == null || flagVirtual.isBlank()) {
            flagVirtual = "0";
        }
    }
}
