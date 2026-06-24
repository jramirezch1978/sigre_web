package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tipo_trabajador_rtps", schema = "rrhh")
public class TipoTrabajadorRtps extends BaseEntity {
    @Column(name = "codigo", length = 20, nullable = false, unique = true)
    private String codigo;
    @Column(name = "nombre", length = 200, nullable = false)
    private String nombre;
    @Column(name = "flag_pensionista", length = 1)
    private String flagPensionista;
}
