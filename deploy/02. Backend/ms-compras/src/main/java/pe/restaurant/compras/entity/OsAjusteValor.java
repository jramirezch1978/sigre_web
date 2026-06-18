package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "os_ajuste_valor", schema = "compras")
public class OsAjusteValor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "orden_servicio_det_id", nullable = false)
    private Long ordenServicioDetId;

    @Column(name = "importe_anterior", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeAnterior;

    @Column(name = "importe_nuevo", nullable = false, precision = 18, scale = 4)
    private BigDecimal importeNuevo;

    @Column(name = "motivo", columnDefinition = "TEXT")
    private String motivo;

    @Column(name = "created_by", nullable = false)
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }
}
