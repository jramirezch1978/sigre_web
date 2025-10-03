package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;

@Entity
@Table(name = "seccion")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "id")
public class SeccionRemote {

    @EmbeddedId
    private SeccionRemoteId id;

    @Column(name = "COD_JEFE_SECCION", length = 8)
    private String codJefeSeccion;

    @Column(name = "DESC_SECCION", length = 30)
    private String descripcionSeccion;

    @Column(name = "PORC_SCTR_IPSS", precision = 4, scale = 2)
    @Builder.Default
    private BigDecimal porcentajeSctrIpss = BigDecimal.ZERO;

    @Column(name = "PORC_SCTR_ONP", precision = 4, scale = 2)
    @Builder.Default
    private BigDecimal porcentajeSctrOnp = BigDecimal.ZERO;

    @Column(name = "FLAG_REPLICACION", length = 1)
    @Builder.Default
    private String flagReplicacion = "1";

    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";

    // Método helper para verificar si está activo
    public boolean isActivo() {
        return "1".equals(flagEstado);
    }

    // Métodos helper para acceder a las partes de la clave
    public String getCodArea() {
        return id != null ? id.getCodArea() : null;
    }

    public String getCodSeccion() {
        return id != null ? id.getCodSeccion() : null;
    }

    public void setCodArea(String codArea) {
        if (id == null) {
            id = new SeccionRemoteId();
        }
        id.setCodArea(codArea);
    }

    public void setCodSeccion(String codSeccion) {
        if (id == null) {
            id = new SeccionRemoteId();
        }
        id.setCodSeccion(codSeccion);
    }
}
