package com.sigre.contabilidad.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class CajaBancosAsientoRequest {

    @NotNull(message = "El ID de caja_bancos es obligatorio")
    private Long id;

    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;

    private LocalDate fechaEmision;

    private Long monedaId;

    private Long entidadContribuyenteId;

    private BigDecimal impTotal;

    private Long bancoCntaId;

    private Long bancoCntaRefId;

    @NotNull(message = "El concepto financiero de cabecera es obligatorio")
    private Long conceptoFinancieroId;

    private BigDecimal tasaCambio;

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

    private String observacion;

    private String flagTipoTransaccion;

    private Long docTipoId;

    private String nroDoc;

    @NotNull(message = "Los detalles son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle")
    @Valid
    private List<CajaBancosDetAsientoRequest> detalles;
}
