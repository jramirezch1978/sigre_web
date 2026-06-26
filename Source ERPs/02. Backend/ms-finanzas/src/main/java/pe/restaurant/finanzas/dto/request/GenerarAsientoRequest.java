package pe.restaurant.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
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

    private Long sucursalId;

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
