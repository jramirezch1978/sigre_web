package pe.restaurant.activos.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfDocumentoRequest {

    @NotNull(message = "El ID del activo es obligatorio")
    private Long afMaestroId;

    @NotBlank(message = "El tipo de documento es obligatorio")
    @Size(max = 50, message = "El tipo de documento no puede exceder 50 caracteres")
    private String tipoDocumento;

    @NotBlank(message = "El nombre del archivo es obligatorio")
    @Size(max = 255, message = "El nombre del archivo no puede exceder 255 caracteres")
    private String nombreArchivo;

    @NotBlank(message = "La ruta del archivo es obligatoria")
    @Size(max = 500, message = "La ruta del archivo no puede exceder 500 caracteres")
    private String rutaArchivo;

    @Size(max = 500, message = "La descripción no puede exceder 500 caracteres")
    private String descripcion;

    @NotNull(message = "La fecha de carga es obligatoria")
    private LocalDate fechaCarga;

    private Long tamanioBytes;

    @Size(max = 10, message = "La extensión no puede exceder 10 caracteres")
    private String extension;

    @NotNull(message = "El ID del usuario que carga es obligatorio")
    private Long usuarioCargaId;
}
