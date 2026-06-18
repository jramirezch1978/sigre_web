package pe.restaurant.finanzas.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AprobarSolicitudRequest {

    private String observacion;

    private Boolean crearOrdenGiro = false;
}
