package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MovimientoDetalleResponse {

    private Long id;
    private Long sucursalId;
    private String sucursalNombre;
    private Long almacenId;
    private String almacenNombre;
    private Long articuloMovTipoId;
    private String articuloMovTipoDescripcion;
    /** Número de vale legible (BD: {@code nro_vale}). */
    private String nroVale;
    private LocalDate fechaMov;
    private LocalDate fecProduccion;
    private Long proveedorId;
    private String nomReceptor;
    private Long tipoDocIntId;
    private String nroDocInt;
    private Long tipoDocExtId;
    private String nroDocExt;
    /** DDL: {@code tipo_referencia_origen} — {@code I|C|V|T|G|P}. */
    private String tipoReferenciaOrigen;
    private Long ordenCompraId;
    private Long progComprasId;
    private Long ordenTrasladoId;
    private Long ordenTrabajoId;
    private Long ordenVentaId;
    private String observaciones;
    /** DDL {@code vale_mov.vale_mov_orig_id}: referencia al vale original (devoluciones). */
    private Long valeMovOrigId;
    private String flagEstado;
    private Long createdBy;
    private UsuarioResumenDto createdByUsuario;
    private OffsetDateTime fecCreacion;
    private Long updatedBy;
    private UsuarioResumenDto updatedByUsuario;
    private OffsetDateTime fecModificacion;
    private List<MovimientoLineaResponse> lineas;
}
