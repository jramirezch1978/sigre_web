package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "seccion")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "id")
public class SeccionLocal {

    @EmbeddedId
    private SeccionLocalId id;

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

    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;

    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error

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
            id = new SeccionLocalId();
        }
        id.setCodArea(codArea);
    }

    public void setCodSeccion(String codSeccion) {
        if (id == null) {
            id = new SeccionLocalId();
        }
        id.setCodSeccion(codSeccion);
    }
}
