package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LotePalletResponse {

    private Long id;
    private Long almacenId;
    private Long articuloId;
    private String nroLote;
    private LocalDate fechaProduccion;
    private LocalDate fechaVencimiento;
    private String observacion;
    private String flagEstado;
}
