package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class EntidadContribuyenteTelefonoResponse {
    private Long id;
    private Long entidadContribuyenteId;
    private Short item;
    private String descripcion;
    private String codigoPais;
    private String codigoCiudad;
    private String numero;
    private String flagFax;
    private String flagEstado;
}
