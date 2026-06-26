package pe.restaurant.activos.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class AfSoftwareResponse {
    private Long id;
    private Long afMaestroId;
    private String licencia;
    private String proveedorSoftware;
    private LocalDate fechaVigenciaIni;
    private LocalDate fechaVigenciaFin;
    private String soporte;
    private String flagEstado;
}
