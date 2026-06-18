package pe.restaurant.core.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class RelacionComercialDetalleResponse extends RelacionComercialResponse {
    private List<ContactoResponse> contactos;
    private List<CuentaBancariaResponse> cuentasBancarias;
    private List<EntidadContribuyenteTelefonoResponse> telefonos;
    private List<EntidadContribuyenteRepresentanteResponse> representantes;
}
