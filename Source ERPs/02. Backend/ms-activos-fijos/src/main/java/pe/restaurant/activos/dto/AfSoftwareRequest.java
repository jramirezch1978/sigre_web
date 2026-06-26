package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDate;

@Data
public class AfSoftwareRequest {

    @NotNull
    private Long afMaestroId;

    @Size(max = 120)
    private String licencia;

    @Size(max = 180)
    private String proveedorSoftware;

    private LocalDate fechaVigenciaIni;
    private LocalDate fechaVigenciaFin;

    @Size(max = 180)
    private String soporte;
}
