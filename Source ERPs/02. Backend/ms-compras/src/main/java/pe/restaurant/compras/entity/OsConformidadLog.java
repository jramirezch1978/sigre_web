package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "os_conformidad_log", schema = "compras")
public class OsConformidadLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "orden_servicio_det_id", nullable = false)
    private Long ordenServicioDetId;

    @Column(name = "accion", nullable = false, length = 20)
    private String accion;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "fecha")
    private OffsetDateTime fecha;

    @Column(name = "observacion", columnDefinition = "TEXT")
    private String observacion;

    @PrePersist
    void prePersist() {
        fecha = OffsetDateTime.now();
    }
}
