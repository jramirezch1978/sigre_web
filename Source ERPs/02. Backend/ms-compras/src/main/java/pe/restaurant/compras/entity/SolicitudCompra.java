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
@Table(name = "solicitud_compra", schema = "compras")
public class SolicitudCompra {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sucursal_id")
    private Long sucursalId;

    @Column(name = "nrol_sol_compra", nullable = false, length = 12, unique = true)
    private String nroSolicitud;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(name = "solicitante_id")
    private Long solicitanteId;

    @Column(length = 20)
    private String prioridad = "MEDIA";

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(columnDefinition = "TEXT")
    private String justificacion;

    @Column(name = "created_by")
    private Long createdBy;

    @Column(name = "fec_creacion")
    private OffsetDateTime fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private OffsetDateTime fecModificacion;

    @OneToMany(mappedBy = "solicitudCompra", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SolicitudCompraDet> lineas = new ArrayList<>();

    @PrePersist
    void prePersist() {
        fecCreacion = OffsetDateTime.now();
    }

    @PreUpdate
    void preUpdate() {
        fecModificacion = OffsetDateTime.now();
    }

    public void addLinea(SolicitudCompraDet det) {
        lineas.add(det);
        det.setSolicitudCompra(this);
    }
}
