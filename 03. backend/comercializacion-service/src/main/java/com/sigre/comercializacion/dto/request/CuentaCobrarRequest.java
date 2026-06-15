package com.sigre.comercializacion.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaCobrarRequest {

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long clienteId;

    @NotNull
    private Long docTipoId;

    private String serie;
    private String numero;

    @NotNull
    private LocalDate fechaEmision;

    private LocalDate fechaVencimiento;
    private Long monedaId;
    private BigDecimal total;
    private BigDecimal saldo;

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

    @Valid
    private List<CuentaCobrarMovimientoRequest> movimientos;
}

