package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalDateTime;

@Entity
@Table(name = "af_historial", schema = "activos")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AfHistorial extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "tipo_evento", nullable = false, length = 50)
    private String tipoEvento;

    @Column(name = "descripcion", nullable = false, length = 500)
    private String descripcion;

    @Column(name = "valor_anterior", length = 200)
    private String valorAnterior;

    @Column(name = "valor_nuevo", length = 200)
    private String valorNuevo;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "fecha_evento", nullable = false)
    private LocalDateTime fechaEvento;

    @Column(name = "ip_origen", length = 50)
    private String ipOrigen;

    @Column(name = "modulo", length = 50)
    private String modulo;
}
