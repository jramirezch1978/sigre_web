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
@Table(name = "log_acceso", schema = "auth")
public class LogAcceso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id")
    private Long usuarioId;

    @Column(name = "empresa_id", nullable = false)
    private Long empresaId;

    @Column(nullable = false, length = 60)
    private String evento;

    @Column(nullable = false)
    private Boolean exito;

    @Column(nullable = false, length = 10)
    private String nivel = "INFO";

    @Column(length = 64)
    private String ip;

    @Column(name = "ip_privada", length = 64)
    private String ipPrivada;

    @Column(name = "sistema_operativo", length = 120)
    private String sistemaOperativo;

    @Column(name = "user_agent", columnDefinition = "TEXT")
    private String userAgent;

    @Column(name = "fecha_login", nullable = false)
    private OffsetDateTime fechaLogin;

    @Column(name = "fecha_logout")
    private OffsetDateTime fechaLogout;

    @PrePersist
    protected void onCreate() {
        if (fechaLogin == null) {
            fechaLogin = OffsetDateTime.now();
        }
    }
}
