package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DetraccionRequest {

    private Long cntasPagarId;

    @Size(max = 12, message = "El número de detracción no puede exceder 12 caracteres")
    private String nroDetraccion;

    private LocalDate fechaRegistro;

    @Size(max = 15, message = "El número de depósito no puede exceder 15 caracteres")
    private String nroDeposito;

    private LocalDate fechaDeposito;

    @NotNull(message = "El importe es obligatorio")
    @Positive(message = "El importe debe ser mayor a cero")
    private BigDecimal importe;

    @Size(max = 1, message = "El flag tabla no puede exceder 1 carácter")
    private String flagTabla;

    @Size(max = 2, message = "El origen caja banco no puede exceder 2 caracteres")
    private String orgCajaBanc;

    private Long nroRegCajaBanc;

    @Size(max = 4, message = "El tipo documento CxC no puede exceder 4 caracteres")
    private String tipoDocCxc;

    @Size(max = 10, message = "El número documento CxC no puede exceder 10 caracteres")
    private String nroDocCxc;
}
