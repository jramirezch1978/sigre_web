package com.sigre.asistencia.dto;

import com.sigre.asistencia.entity.Maestro;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TrabajadorResponseDto {
    private String codTrabajador;
    private String nombreCompleto;
    private String dni;
    private String centroCosto;
    private String email;
    private String telefono;
    private boolean activo;
    private boolean marcaReloj;
    
    // Constructor desde entidad Maestro
    public TrabajadorResponseDto(Maestro maestro) {
        this.codTrabajador = maestro.getCodTrabajador();
        this.nombreCompleto = maestro.getNombreCompleto();
        this.dni = maestro.getDni();
        this.centroCosto = maestro.getCentroCosto();
        this.email = maestro.getEmail();
        this.telefono = maestro.getTelefono1();
        this.activo = maestro.isActivo();
        this.marcaReloj = maestro.isMarcaReloj();
    }
}
