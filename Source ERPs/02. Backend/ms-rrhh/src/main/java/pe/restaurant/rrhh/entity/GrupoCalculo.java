package pe.restaurant.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import pe.restaurant.common.entity.BaseEntity;

/**
 * Catálogo SIGRE GRUPO_CALCULO — agrupador de conceptos de planilla.
 * Seed inicial: ddl/seed/07-seed-grupo-calculo-sigre.sql (143 filas).
 */
@Entity
@Table(name = "grupo_calculo", schema = "rrhh",
    uniqueConstraints = @UniqueConstraint(name = "UQ_GRUPO_CALCULO_CODIGO", columnNames = "codigo"))
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GrupoCalculo extends BaseEntity {

    @Column(name = "codigo", nullable = false, length = 3)
    private String codigo;

    @Column(name = "nombre", length = 50)
    private String nombre;

    /** FK a rrhh.concepto_planilla — concepto generador del grupo (puede ser null). */
    @Column(name = "concepto_gen_id")
    private Long conceptoGenId;

    /** FK a rrhh.concepto_planilla — concepto régimen laboral (puede ser null). */
    @Column(name = "concepto_reg_lab_id")
    private Long conceptoRegLabId;

    /** '1' = aplica lógica por sección (SENATI), '0' = no. */
    @Column(name = "flag_seccion", nullable = false, length = 1)
    private String flagSeccion = "0";

    @Column(name = "flag_replicacion", nullable = false, length = 1)
    private String flagReplicacion = "1";

    @Column(name = "flag_estado", nullable = false, length = 1)
    private String flagEstado = "1";
}
