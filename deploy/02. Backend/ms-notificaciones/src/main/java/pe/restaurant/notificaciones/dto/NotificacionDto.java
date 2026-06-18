package pe.restaurant.notificaciones.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificacionDto {
    private Long id;
    private Long empresaId;
    private String titulo;
    private String descripcion;
    private String tipo;
    private boolean leido;
    private OffsetDateTime creadoEn;
}
