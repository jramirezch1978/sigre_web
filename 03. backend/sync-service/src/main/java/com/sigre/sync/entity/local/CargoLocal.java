package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.time.LocalDate;

@Entity
@Table(name = "cargo")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CargoLocal {

    @Id
    @Column(name = "COD_CARGO", length = 8)
    private String codCargo;

    @Column(name = "DESC_CARGO", length = 100)
    private String descCargo;

    @Column(name = "CATEGORIA", length = 10)
    private String categoria;

    @Column(name = "FLAG_REPLICACION", length = 1)
    @Builder.Default
    private String flagReplicacion = "1";

    @Column(name = "PERFIL_RUTA", length = 100)
    private String perfilRuta;

    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";

    @Column(name = "NIVEL", precision = 1, scale = 0)
    private Integer nivel;

    @Column(name = "COD_OCUPACION_RTPS", length = 6)
    private String codOcupacionRtps;

    @Lob
    @Column(name = "MANUAL_MOF")
    private byte[] manualMof;

    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;

    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error

    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}

