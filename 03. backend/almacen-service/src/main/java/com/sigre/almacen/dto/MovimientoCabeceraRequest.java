package com.sigre.almacen.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class MovimientoCabeceraRequest {

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long almacenId;

    @NotNull
    private Long articuloMovTipoId;

    @NotNull
    private LocalDate fechaMov;

    private LocalDate fecProduccion;

    private Long proveedorId;

    private String nomReceptor;

    private Long tipoDocIntId;

    private String nroDocInt;

    private Long tipoDocExtId;

    private String nroDocExt;

    /** DDL: {@code tipo_referencia_origen} — {@code I|C|V|T|G|P} o null. */
    private String tipoReferenciaOrigen;

    private Long ordenCompraId;

    private Long progComprasId;

    private Long ordenTrasladoId;

    private Long ordenTrabajoId;

    private Long ordenVentaId;

    private String observaciones;

    /** DDL: {@code vale_mov_orig_id} — vale original en devoluciones u homologaciones. */
    private Long valeMovOrigId;

    @NotEmpty
    @Valid
    private List<MovimientoLineaRequest> lineas;
}
