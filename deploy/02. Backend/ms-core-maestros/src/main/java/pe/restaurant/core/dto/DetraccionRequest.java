package pe.restaurant.core.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DetraccionRequest {
    @NotBlank
    @Size(max = 3)
    private String bienServ;

    @Size(max = 100)
    private String descripcion;

    @Size(max = 1)
    private String flagEstado;

    @Size(max = 2)
    private String codSunatPdbe;

    @NotNull
    private BigDecimal tasaPdbe = BigDecimal.ZERO;

    @Size(max = 1)
    private String flagIndImp;

    private Long cntblTipoDetraccionId;

    @NotNull
    private BigDecimal montoMinDepre = BigDecimal.ZERO;
}
