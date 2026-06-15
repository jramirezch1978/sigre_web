package com.sigre.produccion.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.AuditOnlyMappedEntity;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "costeo_produccion", schema = "produccion")
public class CosteoProduccion extends AuditOnlyMappedEntity {

    @Column(name = "orden_trabajo_id")
    private Long ordenTrabajoId;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "costo_materia_prima", precision = 18, scale = 4)
    private BigDecimal costoMateriaPrima;

    @Column(name = "costo_mano_obra", precision = 18, scale = 4)
    private BigDecimal costoManoObra;

    @Column(name = "costo_indirecto", precision = 18, scale = 4)
    private BigDecimal costoIndirecto;

    @Column(name = "costo_total", precision = 18, scale = 4)
    private BigDecimal costoTotal;

    @Column(name = "costo_unitario", precision = 18, scale = 4)
    private BigDecimal costoUnitario;

    @Column(name = "rendimiento_real", precision = 18, scale = 4)
    private BigDecimal rendimientoReal;

    @Column(name = "porcentaje_merma_real", precision = 8, scale = 4)
    private BigDecimal porcentajeMermaReal;
}
