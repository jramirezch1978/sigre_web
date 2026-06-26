package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfDocumentoResponse {
    private Long id;
    private Long afMaestroId;
    private String tipoDocumento;
    private String nombreArchivo;
    private String rutaArchivo;
    private String descripcion;
    private LocalDate fechaCarga;
    private Long tamanioBytes;
    private String extension;
    private Long usuarioCargaId;
}
