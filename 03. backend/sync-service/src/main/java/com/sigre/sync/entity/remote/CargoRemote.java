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
    @Column(name = "COD_CARGO", length = 4)
    private String codCargo;

    @Column(name = "DESC_CARGO", length = 50)
    private String descCargo;

    @Column(name = "FLAG_REPLICACION", length = 1)
    @Builder.Default
    private String flagReplicacion = "1";

    @Column(name = "FLAG_ESTADO", length = 1)
    @Builder.Default
    private String flagEstado = "1";

    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}

