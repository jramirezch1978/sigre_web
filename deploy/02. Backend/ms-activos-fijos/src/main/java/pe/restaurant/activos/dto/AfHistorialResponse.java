package pe.restaurant.activos.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfHistorialResponse {
    private Long id;
    private Long afMaestroId;
    private String tipoEvento;
    private String descripcion;
    private String valorAnterior;
    private String valorNuevo;
    private Long usuarioId;
    private LocalDateTime fechaEvento;
    private String ipOrigen;
    private String modulo;
}
