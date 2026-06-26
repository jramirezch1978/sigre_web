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
@Table(name = "conformidad_servicio_det", schema = "compras")
public class ConformidadServicioDet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conformidad_servicio_id", nullable = false)
    private ConformidadServicio conformidadServicio;

    @Column(nullable = false)
    private Integer secuencia;

    @Column(columnDefinition = "TEXT")
    private String descripcion;

    @Column(precision = 18, scale = 4)
    private BigDecimal cantidad;

    @Column(name = "precio_unitario", precision = 18, scale = 4)
    private BigDecimal precioUnitario;

    @Column(precision = 18, scale = 4)
    private BigDecimal subtotal;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }
}
