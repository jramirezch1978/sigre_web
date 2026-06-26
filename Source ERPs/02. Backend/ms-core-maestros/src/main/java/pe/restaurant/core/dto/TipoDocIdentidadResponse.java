package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class TipoDocIdentidadResponse {
    private Long id;
    private String codigo;
    private String nombre;
    private String tipoDoc;
    private String tipoDocAfpnet;
    private String flagDocBbva;
    private String flagEstado;
}
