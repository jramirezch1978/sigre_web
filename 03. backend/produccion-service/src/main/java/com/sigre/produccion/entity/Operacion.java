package com.sigre.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "operacion", schema = "produccion")
public class Operacion extends BaseEntity {

    @Column(name = "orden_trabajo_id", nullable = false)
    private Long ordenTrabajoId;

    @Column(name = "nro_operacion", nullable = false)
    private Integer nroOperacion;

    @Column(name = "labor_id")
    private Long laborId;

    @Column(name = "ejecutor_id")
    private Long ejecutorId;

    @Column(name = "entidad_contribuyente_id")
    private Long entidadContribuyenteId;

    @Column(name = "centros_costo_id")
    private Long centrosCostoId;

    @Column(name = "unidad_medida_id")
    private Long unidadMedidaId;

    @Column(name = "descripcion", length = 2000)
    private String descripcion;

    @Column(name = "nro_personas")
    private Integer nroPersonas;

    @Column(name = "fec_inicio_estimado")
    private LocalDate fecInicioEstimado;

    @Column(name = "fec_inicio")
    private LocalDate fecInicio;

    @Column(name = "fec_fin")
    private LocalDate fecFin;

    @Column(name = "dias_para_inicio", precision = 5, scale = 2)
    private BigDecimal diasParaInicio;

    @Column(name = "dias_duracion_proy", precision = 5, scale = 2)
    private BigDecimal diasDuracionProy;

    @Column(name = "dias_holgura")
    private Integer diasHolgura;

    @Column(name = "cantidad_proyectada", precision = 18, scale = 4)
    private BigDecimal cantidadProyectada;

    @Column(name = "cantidad_real", precision = 18, scale = 4)
    private BigDecimal cantidadReal;

    @Column(name = "costo_unitario", precision = 18, scale = 4)
    private BigDecimal costoUnitario = BigDecimal.ZERO;

    @Column(name = "costo_proyectado", precision = 18, scale = 4)
    private BigDecimal costoProyectado = BigDecimal.ZERO;

    @Column(name = "observacion", length = 3000)
    private String observacion;
}
