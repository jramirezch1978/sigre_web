package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.finanzas.validation.AtLeastOneNotNull;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@AtLeastOneNotNull(fieldNames = {"cntasPagarId", "cntasCobrarId"}, message = "Debe especificar al menos una cuenta por pagar o una cuenta por cobrar")
public class LiquidacionDetalleRequest {

    @NotNull(message = "El item es obligatorio")
    @Positive(message = "El item debe ser mayor a cero")
    private Integer item;

    @Size(max = 2, message = "El origen del documento de referencia no puede exceder 2 caracteres")
    private String origenDocRef;

    private Long monedaId;

    @NotNull(message = "El concepto financiero es obligatorio")
    private Long conceptoFinancieroId;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long centrosCostoId;

    private Short factorSigno;

    @NotNull(message = "El importe es obligatorio")
    private BigDecimal importe;

    @Size(max = 1, message = "El flag de retención no puede exceder 1 caracter")
    private String flagRetencion = "0";

    private BigDecimal importeRetenido = BigDecimal.ZERO;

    @Size(max = 1, message = "El flag de provisionado no puede exceder 1 caracter")
    private String flagProvisionado = "0";
}
