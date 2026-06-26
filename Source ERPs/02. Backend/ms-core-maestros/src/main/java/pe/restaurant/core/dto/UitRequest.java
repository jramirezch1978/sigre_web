package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotNull;
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
public class UitRequest {

    @NotNull
    private Integer ano;

    @NotNull
    private BigDecimal importe;

    @NotNull
    private LocalDate fecIniVigen;

    private String flagEstado = "1";
}
