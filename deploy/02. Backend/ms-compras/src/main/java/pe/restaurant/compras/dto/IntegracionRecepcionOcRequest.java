package pe.restaurant.compras.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
public class IntegracionRecepcionOcRequest {

    private Long ordenCompraId;
    private Long articuloMovTipoId;
    private Long almacenId;
    private LocalDate fechaMov;
    private String observaciones;
}
