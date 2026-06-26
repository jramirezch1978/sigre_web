package pe.restaurant.common.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.Instant;
import java.util.UUID;

/**
 * Evento base para comunicación asíncrona vía RabbitMQ.
 * Todos los eventos de dominio deben heredar de esta clase.
 */
@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
public abstract class BaseEvent {

    @Builder.Default
    private String eventId = UUID.randomUUID().toString();

    private String eventType;

    @Builder.Default
    private Instant timestamp = Instant.now();

    private Long empresaId;
    private Long sucursalId;
    private Long usuarioId;
    private String moduloOrigen;
}
