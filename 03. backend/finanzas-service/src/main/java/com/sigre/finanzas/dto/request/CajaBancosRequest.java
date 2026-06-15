package com.sigre.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
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
public class CajaBancosRequest {

    @NotBlank(message = "El tipo de transacción es obligatorio")
    @Size(max = 1, message = "El tipo de transacción debe ser un solo carácter")
    private String flagTipoTransaccion;

    @NotNull(message = "La cuenta bancaria es obligatoria")
    private Long bancoCntaId;

    private Long bancoCntaRefId;

    @NotNull(message = "La fecha de emisión es obligatoria")
    private LocalDate fechaEmision;

    private LocalDate fechaProgramada;

    private Long monedaId;

    private Long entidadContribuyenteId;

    @NotNull(message = "El importe total es obligatorio")
    @Positive(message = "El importe total debe ser mayor a cero")
    private BigDecimal impTotal;

    @NotNull(message = "El concepto financiero es obligatorio")
    private Long conceptoFinancieroId;

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

    private Long docTipoId;

    @Size(max = 12, message = "El número de documento no puede exceder 12 caracteres")
    private String nroDoc;

    @Size(max = 500, message = "La observación no puede exceder 500 caracteres")
    private String observacion;

    private BigDecimal tasaCambio;

    private Long medioPagoId;

    // --- CAMPOS ADICIONALES (DDL COMPLETO) ---
    // Campos adicionales presentes en la base de datos que no se utilizan actualmente
    // pero se mantienen para compatibilidad y uso futuro
    private String flagAdelanto;           // CHAR(1) - Indica si es adelanto ('1' si es adelanto, '0' si no)
    private String flagConciliacion;       // CHAR(1) - Estado de conciliación bancaria
    private String flagPadronSunat;        // CHAR(1) - Padrón SUNAT
    private Long facturacionSimplId;       // BIGINT - FK facturación simplificada
    private String flagFormaPagoFs;        // CHAR(1) - Forma pago facturación simplificada
    private Long factSimplPagoId;          // BIGINT - FK pago facturación simplificada

    @Valid
    @NotNull(message = "Los detalles son obligatorios")
    @Size(min = 1, message = "Debe incluir al menos un detalle")
    private List<CajaBancosDetalleRequest> detalles;
}
