package pe.restaurant.core.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DetraccionResponse {
    private Long id;
    private String bienServ;
    private String descripcion;
    private String flagEstado;
    private String codSunatPdbe;
    private BigDecimal tasaPdbe;
    private String flagIndImp;
    private Long cntblTipoDetraccionId;
    private BigDecimal montoMinDepre;
}
