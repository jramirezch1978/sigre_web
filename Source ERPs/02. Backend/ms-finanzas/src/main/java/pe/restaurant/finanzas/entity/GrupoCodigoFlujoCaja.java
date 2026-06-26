package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;
import java.util.Date;

@Entity
@Table(name = "grupo_codigo_flujo_caja", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(columnNames = {"codigo"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper=false)
public class GrupoCodigoFlujoCaja extends BaseEntity {

    @Column(name = "codigo", nullable = false, length = 20, unique = true)
    private String codigo;

    @Column(name = "nombre", length = 150)
    private String nombre;

    @Column(name = "flag_reporte", length = 1)
    private String flagReporte;

    @Column(name = "factor", length = 1)
    private String factor;

    @Column(name = "orden", nullable = false)
    private Integer orden = 0;

    @Column(name = "actividad_flujo_caja_id", nullable = false)
    private Long actividadFlujoCajaId;

    @Column(name = "fec_registro", nullable = false)
    private Date fecRegistro = new Date();
}
