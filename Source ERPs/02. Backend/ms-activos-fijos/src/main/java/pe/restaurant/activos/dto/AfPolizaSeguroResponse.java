package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AfPolizaSeguroResponse {

    private Long id;
    private Long afAseguradoraId;
    private String numeroPoliza;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private BigDecimal prima;
    private BigDecimal cobertura;
    private String flagEstado;
}
