package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DocumentoDirectoDetalleRequest {

    @NotNull(message = "El ítem es obligatorio")
    @Positive(message = "El ítem debe ser mayor a cero")
    private Integer item;

    @NotNull(message = "El concepto financiero es obligatorio")
    private Long conceptoFinancieroId;

    @NotBlank(message = "La descripción es obligatoria")
    private String descripcion;

    private Long articuloId;

    @NotNull(message = "La cantidad es obligatoria")
    private BigDecimal cantidad;

    @NotNull(message = "El precio unitario es obligatorio")
    private BigDecimal precioUnitario;

    @NotNull(message = "La fecha del movimiento es requerida")
    private LocalDate fechaMov;

    @NotBlank(message = "El tipo de movimiento es requerido")
    private String tipoMov = "DIRECTO";

    @NotNull(message = "El monto es requerido")
    @Positive(message = "El monto debe ser mayor que 0")
    private BigDecimal monto;

    @NotNull(message = "El centro de costo es obligatorio")
    private Long centrosCostoId;

    private List<DetImpuestoRequest> impuestos;

    private Long ordenCompraDetId;

    private Long ordenServicioDetId;

    private Long valeMovDetId;

    private Long sucursalRefId;

    private Long docTipoRefId;

    private String nroRef;

    private Integer itemRef;

    private LocalDate fecMovilidad;

    private String movDesde;

    private String movHasta;

    private Long trabajadorId;

    private String referencia;
}
