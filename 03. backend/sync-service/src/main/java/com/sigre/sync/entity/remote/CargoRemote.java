package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

@Entity
@Table(name = "cargo")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CargoRemote {

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

    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}

