package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadDetraccionResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private Long detrBienServId;
    private BigDecimal porcentaje;
    private String flagEstado;
}
