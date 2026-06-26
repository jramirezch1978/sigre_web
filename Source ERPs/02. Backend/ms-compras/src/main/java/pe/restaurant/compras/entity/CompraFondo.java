package pe.restaurant.compras.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "compra_fondo", schema = "compras",
        uniqueConstraints = @UniqueConstraint(columnNames = {"centros_costo_id", "anio"}))
public class CompraFondo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "centros_costo_id", nullable = false)
    private Long centrosCostoId;

    @Column(name = "monto_total", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoTotal = BigDecimal.ZERO;

    @Column(name = "monto_usado", nullable = false, precision = 18, scale = 4)
    private BigDecimal montoUsado = BigDecimal.ZERO;

    @Column(nullable = false)
    private Integer anio;

    @Column(name = "flag_estado", length = 1)
    private String flagEstado = "1";
}
