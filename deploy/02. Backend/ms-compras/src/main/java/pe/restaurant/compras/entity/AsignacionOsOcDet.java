package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;
import java.time.OffsetDateTime;

@Getter @Setter @NoArgsConstructor
@Entity @Table(name = "asignacion_os_oc_det", schema = "compras")
public class AsignacionOsOcDet {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "asignacion_os_oc_id", nullable = false)
    private AsignacionOsOc asignacionOsOc;
    @Column(name = "orden_servicio_det_id", nullable = false)
    private Long ordenServicioDetId;
    @Column(name = "orden_compra_det_id", nullable = false)
    private Long ordenCompraDetId;
    @Column(name = "monto_aplicado", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoAplicado = BigDecimal.ZERO;
    @Column(name = "created_by")
    private Long createdBy;
    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;
    @PrePersist
    void prePersist() { fecCreacion = OffsetDateTime.now(); }
}
