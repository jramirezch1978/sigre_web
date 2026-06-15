package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Datos mínimos de {@code auth.usuario} para enriquecer FK y auditoría en respuestas API.
 * {@code numeroDocumento}: en el DDL actual de {@code auth.usuario} no hay documento de identidad;
 * se usa {@code username} como referencia legible adicional (puede ajustarse si se agrega columna).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioResumenDto {

    private Long id;
    private String nombreCompleto;
    /** Referencia humana cuando no existe columna de documento en {@code auth.usuario}. */
    private String numeroDocumento;
}
