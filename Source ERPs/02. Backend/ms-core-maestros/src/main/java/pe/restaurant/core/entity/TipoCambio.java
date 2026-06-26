package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tipo_cambio", schema = "core")
public class TipoCambio extends BaseEntity {

    @Column(name = "moneda_id", nullable = false)
    private Long monedaId;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, precision = 18, scale = 6)
    private BigDecimal compra;

    @Column(nullable = false, precision = 18, scale = 6)
    private BigDecimal venta;
}
