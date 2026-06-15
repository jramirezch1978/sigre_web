package com.sigre.contabilidad.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
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
public class GenerarAsientoRequest {

    @NotNull(message = "El ID del documento cabecera es obligatorio")
    private Long documentoId;

    @NotNull(message = "La fecha del documento es obligatoria")
    private LocalDate fecha;

    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;

    @NotNull(message = "El año del periodo contable es obligatorio")
    @Min(value = 1900, message = "El año debe ser válido")
    private Integer ano;

    @NotNull(message = "El mes del periodo contable es obligatorio")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    @NotNull(message = "El libro contable (cntbl_libro_id) es obligatorio")
    @Positive(message = "El libro contable debe ser un id válido")
    private Long cntblLibroId;

    private Long monedaId;

    private BigDecimal tipoCambio;

    private BigDecimal total;

    private BigDecimal saldo;

    private Long proveedorId;

    private Long clienteId;

    private Long docTipoId;

    private String serie;

    private String numero;

    private Long bancoCntaId;

    private Long bancoCntaRefId;

    private Long solicitudGiroId;

    private String glosa;

    @NotNull(message = "Los detalles del documento son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle")
    @Valid
    private List<DocumentoDetalleRequest> detalles;
}
