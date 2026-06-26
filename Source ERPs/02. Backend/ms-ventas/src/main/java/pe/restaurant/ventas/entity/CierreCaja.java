package pe.restaurant.ventas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.Instant;

@Entity
@Table(name = "cierre_caja", schema = "ventas")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
public class CierreCaja extends BaseEntity {

    @Column(name = "turno_id")
    private Long turnoId;

    @Column(name = "ventas_efectivo", precision = 18, scale = 4)
    private BigDecimal ventasEfectivo = BigDecimal.ZERO;

    @Column(name = "ventas_tarjeta", precision = 18, scale = 4)
    private BigDecimal ventasTarjeta = BigDecimal.ZERO;

    @Column(name = "ventas_digital", precision = 18, scale = 4)
    private BigDecimal ventasDigital = BigDecimal.ZERO;

    @Column(name = "ventas_total", precision = 18, scale = 4)
    private BigDecimal ventasTotal = BigDecimal.ZERO;

    @Column(name = "propinas_total", precision = 18, scale = 4)
    private BigDecimal propinasTotal = BigDecimal.ZERO;

    @Column(name = "fondo_inicial", precision = 18, scale = 4)
    private BigDecimal fondoInicial = BigDecimal.ZERO;

    @Column(name = "fondo_final", precision = 18, scale = 4)
    private BigDecimal fondoFinal;

    @Column(name = "diferencia", precision = 18, scale = 4)
    private BigDecimal diferencia = BigDecimal.ZERO;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "fecha_cierre")
    private Instant fechaCierre;
}
