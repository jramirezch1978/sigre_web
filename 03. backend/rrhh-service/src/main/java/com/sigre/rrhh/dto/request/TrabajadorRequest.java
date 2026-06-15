package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorRequest {

    private Long entidadContribuyenteId;

    @NotBlank(message = "El código de trabajador es obligatorio")
    @Size(max = 20)
    private String codigoTrabajador;

    @NotBlank(message = "Los nombres son obligatorios")
    @Size(max = 120)
    private String nombres;

    @Size(max = 120)
    private String apellidoPaterno;

    @Size(max = 120)
    private String apellidoMaterno;

    private Long tipoDocIdentidadId;

    @Size(max = 30)
    private String numeroDocumento;

    private LocalDate fechaNacimiento;

    private Long sexoId;

    private Long estadoCivilId;

    @Size(max = 300)
    private String direccion;

    @Size(max = 40)
    private String telefono;

    @Size(max = 150)
    private String email;

    @Size(max = 60)
    private String cuentaBancariaSueldo;

    @Size(max = 60)
    private String cuentaCts;

    private Long adminAfpId;

    @Size(max = 30)
    private String cuspp;

    private Long regimenLaboralId;

    private Long areaId;
    private Long cargoId;
    private Long sucursalId;

    private LocalDate fechaIngreso;

    private LocalDate fechaCese;

    @Size(max = 120)
    private String motivoCese;
}
