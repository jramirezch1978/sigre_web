package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

/**
 * Entidad que representa el cálculo de retención de impuesto a la renta de
 * quinta categoría para un trabajador en un período (año/mes) determinado.
 * <p>
 * No extiende {@code BaseEntity} porque la tabla no posee {@code flag_estado};
 * los campos de auditoría se manejan directamente como en {@link Area}.
 */
@Entity
@Table(name = "quinta_categoria", schema = "rrhh")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuintaCategoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "anio", nullable = false)
    private Integer anio;

    @Column(name = "mes", nullable = false)
    private Integer mes;

    @Column(name = "renta_bruta_acumulada", precision = 18, scale = 4)
    private BigDecimal rentaBrutaAcumulada;

    @Column(name = "renta_bruta_proyectada", precision = 18, scale = 4)
    private BigDecimal rentaBrutaProyectada;

    @Column(name = "deduccion_7uit", precision = 18, scale = 4)
    private BigDecimal deduccion7uit;

    @Column(name = "renta_neta", precision = 18, scale = 4)
    private BigDecimal rentaNeta;

    @Column(name = "impuesto_anual_proyectado", precision = 18, scale = 4)
    private BigDecimal impuestoAnualProyectado;

    @Column(name = "retencion_mensual", precision = 18, scale = 4)
    private BigDecimal retencionMensual;

    @Column(name = "retencion_acumulada", precision = 18, scale = 4)
    private BigDecimal retencionAcumulada;

    // Campos de auditoría (manejados directamente)
    @Column(name = "created_by", updatable = false)
    private Long createdBy;

    @Column(name = "fec_creacion", updatable = false)
    private Instant fecCreacion;

    @Column(name = "updated_by")
    private Long updatedBy;

    @Column(name = "fec_modificacion")
    private Instant fecModificacion;
}
