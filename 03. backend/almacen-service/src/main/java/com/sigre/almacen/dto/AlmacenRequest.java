package com.sigre.almacen.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AlmacenRequest extends FlagEstadoRequest {

    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;

    private Long almacenTipoId;

    private Long centrosCostoId;

    private Long proveedorEntidadId;

    private Long responsableUsuarioId;

    @NotBlank(message = "El código de almacén es obligatorio")
    @Size(max = 20)
    private String codigo;

    @NotBlank(message = "El nombre de almacén es obligatorio")
    @Size(max = 150)
    private String nombre;

    @Size(max = 80)
    private String direccion;

    private BigDecimal areaTotal;

    private BigDecimal volTotal;

    @Size(max = 1)
    private String flagCntrlLote;

    private Long ubigeo;

    private Long distritoId;

    @Size(max = 4)
    private String codSunat;

    @Size(max = 1)
    private String flagVirtual;
}
