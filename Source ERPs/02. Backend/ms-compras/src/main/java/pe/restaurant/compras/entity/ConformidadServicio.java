package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "conformidad_servicio", schema = "compras")
public class ConformidadServicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "orden_servicio_id", nullable = false)
    private Long ordenServicioId;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(columnDefinition = "TEXT")
    private String observacion;

    @Column(nullable = false)
    private Boolean aprobado = false;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @OneToMany(mappedBy = "conformidadServicio", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ConformidadServicioDet> lineas = new ArrayList<>();

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }

    public void addLinea(ConformidadServicioDet det) {
        lineas.add(det);
        det.setConformidadServicio(this);
    }
}
