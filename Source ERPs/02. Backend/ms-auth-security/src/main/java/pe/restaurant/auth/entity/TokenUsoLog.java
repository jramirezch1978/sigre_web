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
@Table(name = "token_uso_log", schema = "auth")
public class TokenUsoLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tokens_session_id", nullable = false)
    private Long tokensSessionId;

    @Column(nullable = false, length = 10)
    private String metodo;

    @Column(nullable = false, length = 500)
    private String uri;

    @Column(length = 64)
    private String ip;

    @Column(name = "ip_privada", length = 64)
    private String ipPrivada;

    @Column(name = "user_agent", columnDefinition = "TEXT")
    private String userAgent;

    @Column(length = 60)
    private String microservicio;

    @Column(name = "status_code")
    private Integer statusCode;

    @Column(name = "duracion_ms")
    private Long duracionMs;

    @Column(nullable = false)
    private OffsetDateTime fecha;

    @PrePersist
    protected void onCreate() {
        if (fecha == null) {
            fecha = OffsetDateTime.now();
        }
    }
}
