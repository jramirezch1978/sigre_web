package com.sigre.core.dto;

import java.util.List;
import lombok.Data;

/**
 * Datos ya formateados (strings) que el frontend envía para generar el documento en el backend.
 * headers: cabeceras de columna; filas: cada fila como lista de celdas alineada a headers.
 */
@Data
public class ExportRequest {
    private String titulo;
    private List<String> headers;
    private List<List<String>> filas;
}
