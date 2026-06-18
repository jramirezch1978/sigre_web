package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfMatrizSubClaseRequest {

    @NotNull(message = "La subclase es obligatoria")
    private Long afSubClaseId;

    private Long cuentaActivoId;
    private Long cuentaDepAcumId;
    private Long cuentaGastoDepId;
    private Long cuentaBajaId;
    private Long cuentaResVentaId;
    private Long centroCostoId;
    private Long cuentaGastoSeguroId;
    private Long cuentaPasivoSeguroId;
    private Long cuentaProveedorTransitoriaId;
    private Long cuentaCapitalizacionId;
}
