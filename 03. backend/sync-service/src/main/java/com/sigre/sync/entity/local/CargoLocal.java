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

