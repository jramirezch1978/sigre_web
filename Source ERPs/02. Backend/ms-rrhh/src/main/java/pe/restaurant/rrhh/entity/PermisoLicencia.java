package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

/**
 * Cabecera permiso/licencia ({@code rrhh.permiso_licencia}).
 * Saldo por trabajador, concepto de planilla y periodo laboral.
 * Los tramos operativos (fechas, tipo RTPS, documento) van en {@link PermisoLicenciaDet}.
 */
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "permiso_licencia", schema = "rrhh")
public class PermisoLicencia extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "concepto_planilla_id")
    private Long conceptoPlanillaId;

    @Column(name = "periodo_inicio", nullable = false)
    private Integer periodoInicio;

    @Column(name = "periodo_fin")
    private Integer periodoFin;

    @Column(name = "dias_totales", nullable = false)
    private Integer diasTotales = 0;

    @Column(name = "dias_gozados", nullable = false)
    private Integer diasGozados = 0;
}
