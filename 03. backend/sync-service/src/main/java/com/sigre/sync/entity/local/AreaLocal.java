package com.sigre.sync.entity.local;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import java.time.LocalDate;

@Entity
@Table(name = "area")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "codArea")
public class AreaLocal {

    @Id
    @Column(name = "COD_AREA", length = 1, nullable = false)
    private String codArea;

    @Column(name = "COD_JEFE_AREA", length = 8)
    private String codJefeArea;

    @Column(name = "DESC_AREA", length = 100)
    private String descripcionArea;

    @Column(name = "FLAG_REPLICACION", length = 1)
    @Builder.Default
    private String flagReplicacion = "1";

    // Campos de auditoría para sincronización
    @Column(name = "FECHA_SYNC")
    private LocalDate fechaSync;

    @Column(name = "ESTADO_SYNC", length = 1)
    @Builder.Default
    private String estadoSync = "P"; // P=Pendiente, S=Sincronizado, E=Error

    // Método helper para verificar si está activo
    public boolean isActivo() {
        return "1".equals(flagReplicacion);
    }
}
