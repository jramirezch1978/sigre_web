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

    @Column(name = "numero_documento", length = 30)
    private String numeroDocumento;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "SOLICITUD";

    @Column(name = "fecha_programada")
    private LocalDate fechaProgramada;

    @Column(name = "fecha_aprobacion")
    private LocalDate fechaAprobacion;

    @Column(name = "centro_costo_origen_id")
    private Long centroCostoOrigenId;

    @Column(name = "centro_costo_destino_id")
    private Long centroCostoDestinoId;

    @Column(name = "responsable_ejecucion_id")
    private Long responsableEjecucionId;

    @Column(name = "comentario_rechazo", columnDefinition = "TEXT")
    private String comentarioRechazo;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

}
