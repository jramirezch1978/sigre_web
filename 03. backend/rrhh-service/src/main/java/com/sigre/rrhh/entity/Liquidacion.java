package com.sigre.rrhh.entity;

import jakarta.persistence.*;
import lombok.*;
import com.sigre.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Entidad que representa la liquidación de beneficios sociales (cese)
 * de un trabajador.
 * <p>
 * Extiende {@link BaseEntity} porque la tabla {@code rrhh.liquidacion_benef}
 * posee {@code flag_estado}, igual que {@link Contrato} y {@link Trabajador}.
 * <p>
 * No confundir con {@code finanzas.liquidacion} (liquidación de orden de giro / fondo fijo).
 * <p>
 * Semántica de {@code flagEstado}: {@code "1"}=Pendiente, {@code "2"}=Aprobada,
 * {@code "0"}=Anulada.
 */
@Entity
@Table(name = "liquidacion_benef", schema = "rrhh")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Liquidacion extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false)
    private Long trabajadorId;

    @Column(name = "fecha_cese", nullable = false)
    private LocalDate fechaCese;

    @Column(name = "cts_pendiente", precision = 18, scale = 4)
    private BigDecimal ctsPendiente;

    @Column(name = "vacaciones_truncas", precision = 18, scale = 4)
    private BigDecimal vacacionesTruncas;

    @Column(name = "gratificacion_trunca", precision = 18, scale = 4)
    private BigDecimal gratificacionTrunca;

    @Column(name = "indemnizacion", precision = 18, scale = 4)
    private BigDecimal indemnizacion;

    @Column(name = "total_beneficios", precision = 18, scale = 4)
    private BigDecimal totalBeneficios;

    @Column(name = "total_descuentos", precision = 18, scale = 4)
    private BigDecimal totalDescuentos;

    @Column(name = "neto_pagar", precision = 18, scale = 4)
    private BigDecimal netoPagar;
}
