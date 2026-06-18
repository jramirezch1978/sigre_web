package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfMatrizSubClaseResponse {
    private Long id;
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
    private String flagEstado;
}
