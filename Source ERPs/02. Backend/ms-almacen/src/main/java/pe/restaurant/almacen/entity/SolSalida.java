package pe.restaurant.almacen.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "sol_salida", schema = "almacen")
public class SolSalida {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "almacen_id", nullable = false)
    private Long almacenId;

    @Column(name = "nro_sol_salida", nullable = false, length = 12, unique = true)
    private String numero;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(name = "solicitante_id")
    private Long solicitanteId;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    @Column(columnDefinition = "TEXT")
    private String observacion;

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
