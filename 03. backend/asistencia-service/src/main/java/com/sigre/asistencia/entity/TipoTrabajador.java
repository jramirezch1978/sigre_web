package com.sigre.asistencia.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.EqualsAndHashCode;

@Entity
@Table(name = "tipo_trabajador")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode(of = "tipoTrabajador")
public class TipoTrabajador {

    @Id
    @Column(name = "TIPO_TRABAJADOR", length = 3, nullable = false)
    private String tipoTrabajador;

    @Column(name = "DESC_TIPO_TRA", length = 30)
    private String descripcionTipoTrabajador;

    @Column(name = "FLAG_EMISION_BOLETA", length = 1)
    private String flagEmisionBoleta;

    @Column(name = "FLAG_ESTADO", length = 1)
    private String flagEstado;

    @Column(name = "FLAG_REPLICACION", length = 1)
    private String flagReplicacion;

    // Método helper para verificar si está activo
    public boolean isActivo() {
        return "1".equals(flagEstado);
    }
}
