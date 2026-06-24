package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tipo_trabajador", schema = "rrhh")
public class TipoTrabajador extends BaseEntity {
    @Column(name = "codigo", length = 20, nullable = false, unique = true)
    private String codigo;
    @Column(name = "nombre", length = 200, nullable = false)
    private String nombre;
    @Column(name = "libro_prov_remuneracion")
    private Integer libroProvRemuneracion;
    @Column(name = "libro_prov_gratificacion")
    private Integer libroProvGratificacion;
    @Column(name = "libro_prov_cts")
    private Integer libroProvCts;
    @Column(name = "flag_estado", length = 1, nullable = false)
    private String flagEstado = "1";
}
