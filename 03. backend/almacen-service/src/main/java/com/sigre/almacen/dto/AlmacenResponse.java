package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenResponse {

    private Long id;
    private Long sucursalId;
    private String sucursalCodigo;
    private String sucursalNombre;
    private Long almacenTipoId;
    private String almacenTipoCodigo;
    private String almacenTipoNombre;
    private Long centrosCostoId;
    private String centrosCostoCodigo;
    private String centrosCostoNombre;
    private Long proveedorEntidadId;
    private String proveedorDocumento;
    private String proveedorNombre;
    private Long responsableUsuarioId;
    private String codigo;
    private String nombre;
    private String direccion;
    private BigDecimal areaTotal;
    private BigDecimal volTotal;
    private String flagCntrlLote;
    private Long distritoId;
    private String codSunat;
    private String flagVirtual;
    private String ubigeo;
    private String flagEstado;
    private Long createdBy;
    private UsuarioResumenDto createdByUsuario;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private UsuarioResumenDto updatedByUsuario;
    private OffsetDateTime fecModificacion;
}
