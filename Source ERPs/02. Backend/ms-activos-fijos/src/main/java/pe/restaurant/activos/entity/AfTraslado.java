package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalDate;

@Entity
@Table(name = "af_traslado", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfTraslado extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "ubicacion_origen_id")
    private Long ubicacionOrigenId;

    @Column(name = "ubicacion_destino_id")
    private Long ubicacionDestinoId;

    @Column(name = "solicitante_id")
    private Long solicitanteId;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(name = "fecha_solicitud", nullable = false)
    private LocalDate fechaSolicitud;

    @Column(name = "fecha_ejecucion")
    private LocalDate fechaEjecucion;

    @Column(name = "motivo", columnDefinition = "TEXT")
    private String motivo;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

}
