package pe.restaurant.auth.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "codigo_recuperacion", schema = "auth")
public class CodigoRecuperacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(nullable = false, length = 8)
    private String codigo;

    @Column(name = "expira_en", nullable = false)
    private OffsetDateTime expiraEn;

    @Column(nullable = false)
    private Boolean usado = false;

    @Column(name = "fec_creacion", nullable = false, updatable = false)
    private OffsetDateTime fecCreacion;

    @PrePersist
    protected void onCreate() {
        if (fecCreacion == null) {
            fecCreacion = OffsetDateTime.now();
        }
    }
}
