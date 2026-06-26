package pe.restaurant.core.dto;

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
public class UitResponse {
    private Long id;
    private Integer ano;
    private BigDecimal importe;
    private LocalDate fecIniVigen;
    private String flagEstado;
}
