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

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "receta", schema = "produccion")
public class Receta extends BaseEntity {

    @Column(name = "articulo_producido_id", nullable = false)
    private Long articuloProducidoId;

    @Column(name = "nro_receta", nullable = false, unique = true, length = 12)
    private String nroReceta;

    @Column(name = "nombre", nullable = false, length = 200)
    private String nombre;

    @Column(name = "version", nullable = false)
    private Integer version = 1;

    @Column(name = "rendimiento_esperado", precision = 18, scale = 4)
    private BigDecimal rendimientoEsperado;

    @Column(name = "porcentaje_merma", precision = 8, scale = 4)
    private BigDecimal porcentajeMerma;

    @Column(name = "flag_tipo_receta", nullable = false, length = 1)
    private String flagTipoReceta = "P";

    @Column(name = "costo_mano_obra", precision = 18, scale = 4)
    private BigDecimal costoManoObra = BigDecimal.ZERO;

    @Column(name = "costo_indirecto", precision = 18, scale = 4)
    private BigDecimal costoIndirecto = BigDecimal.ZERO;

    @Column(name = "costo_total_estimado", precision = 18, scale = 4)
    private BigDecimal costoTotalEstimado = BigDecimal.ZERO;
}
