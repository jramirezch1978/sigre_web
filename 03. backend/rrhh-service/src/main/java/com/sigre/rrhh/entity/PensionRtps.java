package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "pension_rtps", schema = "rrhh")
public class PensionRtps extends BaseEntity {
    @Column(name = "codigo", length = 20, nullable = false, unique = true)
    private String codigo;
    @Column(name = "nombre", length = 200, nullable = false)
    private String nombre;
}
