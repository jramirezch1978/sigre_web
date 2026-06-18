package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class CntasCobrarDetAsientoRequest {

    private Long id;

    @NotNull(message = "El concepto financiero es obligatorio en cada detalle")
    private Long conceptoFinancieroId;

    private LocalDate fechaMov;

    private String tipoMov;

    @NotNull(message = "El monto es obligatorio")
    private BigDecimal monto;

    private List<DetImpuestoAsientoRequest> impuestos;

    private String referencia;

    private String glosa;
}
