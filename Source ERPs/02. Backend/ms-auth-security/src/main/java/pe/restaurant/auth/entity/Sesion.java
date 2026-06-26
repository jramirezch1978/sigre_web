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
@Table(name = "sesion", schema = "auth")
public class Sesion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Column(name = "token_id", nullable = false, unique = true, length = 120)
    private String tokenId;

    @Column(length = 64)
    private String ip;

    @Column(name = "user_agent", columnDefinition = "TEXT")
    private String userAgent;

    @Column(name = "expira_en", nullable = false)
    private OffsetDateTime expiraEn;

    @Column(name = "cerrado_en")
    private OffsetDateTime cerradoEn;

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";

    public Boolean getActivo() {
        return "1".equals(flagEstado);
    }

    public void setActivo(Boolean activo) {
        this.flagEstado = Boolean.TRUE.equals(activo) ? "1" : "0";
    }
}
