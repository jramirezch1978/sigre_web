package pe.restaurant.activos.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "af_software", schema = "activos")
public class AfSoftware extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(length = 120)
    private String licencia;

    @Column(name = "proveedor_software", length = 180)
    private String proveedorSoftware;

    @Column(name = "fecha_vigencia_ini")
    private LocalDate fechaVigenciaIni;

    @Column(name = "fecha_vigencia_fin")
    private LocalDate fechaVigenciaFin;

    @Column(length = 180)
    private String soporte;
}
