package com.sigre.asistencia.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AsistenciaResponseDto {
    private String reckey;
    private String codTrabajador;
    private String nombreTrabajador;
    private String tipoMovimiento;
    private String tipoMarcaje;
    private LocalDateTime fechaRegistro;
    private LocalDateTime fechaMovimiento;
    private String mensaje;
    private boolean exitoso;
    
    // Factory methods
    public static AsistenciaResponseDto exitoso(String reckey, String codTrabajador, String nombreTrabajador,
                                               String tipoMovimiento, String tipoMarcaje,
                                               LocalDateTime fechaRegistro, LocalDateTime fechaMovimiento,
                                               String mensaje) {
        return AsistenciaResponseDto.builder()
                .reckey(reckey)
                .codTrabajador(codTrabajador)
                .nombreTrabajador(nombreTrabajador)
                .tipoMovimiento(tipoMovimiento)
                .tipoMarcaje(tipoMarcaje)
                .fechaRegistro(fechaRegistro)
                .fechaMovimiento(fechaMovimiento)
                .mensaje(mensaje)
                .exitoso(true)
                .build();
    }
    
    public static AsistenciaResponseDto error(String mensaje) {
        return AsistenciaResponseDto.builder()
                .mensaje(mensaje)
                .exitoso(false)
                .build();
    }
}