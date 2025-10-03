package com.sigre.sync.entity.remote;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;

@Entity
@Table(name = "area")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "codArea")
public class AreaRemote {

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

    // Método helper para verificar si está activo
    public boolean isActivo() {
        return "1".equals(flagReplicacion);
    }
}
