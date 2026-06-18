package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "solicitud_giro", schema = "finanzas",
    uniqueConstraints = {
        @UniqueConstraint(columnNames = "numero")
    }
)
public class SolicitudGiro extends BaseEntity {

    @Column(name = "sucursal_id", nullable = false)
    private Long sucursalId;

    @Column(name = "solicitante_id")
    private Long solicitanteId;

    @Column(nullable = false, unique = true, length = 12)
    private String numero;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(columnDefinition = "TEXT")
    private String motivo;

    /** O = Orden de Giro, F = Fondo Fijo (CHECK en BD). */
    @Column(name = "tipo_solicitud", nullable = false, length = 1)
    private String tipoSolicitud = "O";

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "aprobador_id")
    private Long aprobadorId;

    @Column(name = "fec_aprobacion")
    private Instant fecAprobacion;

    @Column(name = "fec_rechazo")
    private Instant fecRechazo;

    @Column(name = "motivo_rechazo", columnDefinition = "TEXT")
    private String motivoRechazo;

    @Column(name = "motivo_devolucion", columnDefinition = "TEXT")
    private String motivoDevolucion;

    @Column(name = "aprobador_devolucion_id")
    private Long aprobadorDevolucionId;

    @Column(name = "fec_aprobacion_devolucion")
    private Instant fecAprobacionDevolucion;

    @Column(name = "fec_rechazo_devolucion")
    private Instant fecRechazoDevolucion;

    @Column(name = "motivo_rechazo_devolucion", columnDefinition = "TEXT")
    private String motivoRechazoDevolucion;

    /** A = aprobado, R = rechazado; null si no hay resolucion de devolucion. */
    @Column(name = "flag_estado_devolucion", length = 1)
    private String flagEstadoDevolucion;
}
