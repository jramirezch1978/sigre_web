package com.sigre.contabilidad.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoRequest {
    
    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;

    @NotNull(message = "El ID del libro es obligatorio")
    @Positive(message = "El libro contable debe ser un id válido")
    private Long libroId;

    @NotNull(message = "El año del periodo contable es obligatorio")
    @Min(value = 1900, message = "El año debe ser válido")
    private Integer ano;

    @NotNull(message = "El mes del periodo contable es obligatorio")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;
    
    @NotNull(message = "La fecha del asiento es obligatoria")
    private LocalDate fecha;
    
    @NotBlank(message = "La naturaleza del asiento es obligatoria")
    @Size(max = 1, message = "La naturaleza del asiento debe ser de 1 carácter")
    private String naturalezaAsiento;

    @NotBlank(message = "La glosa es obligatoria")
    private String glosa;

    private BigDecimal tasaCambio;

    @NotBlank(message = "El módulo de origen es obligatorio")
    @Size(max = 1, message = "El módulo de origen debe ser de 1 carácter")
    private String moduloOrigen;

    private Long cntblPreasientoId;

    private Long monedaId;
    
    @NotNull(message = "Los detalles del asiento son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle")
    @Valid
    private List<AsientoDetalleRequest> detalles;
}
