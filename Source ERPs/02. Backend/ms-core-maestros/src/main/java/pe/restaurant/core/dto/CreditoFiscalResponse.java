package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreditoFiscalResponse {
    private Long id;
    private String codigo;
    private String descripcion;
    private String codSunat;
    private String flagTipoAdquisicion;
    private String flagCxpCxc;
    private String tipoAfectacionIgv;
    private String flagEstado;
}
