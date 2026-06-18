package pe.restaurant.contabilidad.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
public class CntblTipoDetraccionRequest {

    @NotBlank
    @Size(max = 20)
    private String codigo;

    @NotBlank
    @Size(max = 200)
    private String descripcion;

    @NotNull
    @DecimalMin(value = "0")
    private BigDecimal porcentaje;

    private Long planContableDetId;

    private LocalDate vigenciaDesde;

    private LocalDate vigenciaHasta;

    @Size(max = 1)
    private String flagEstado;
}
