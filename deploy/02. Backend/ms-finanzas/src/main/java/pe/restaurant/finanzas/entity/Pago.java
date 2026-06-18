package pe.restaurant.finanzas.entity;

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
@Table(name = "pago", schema = "finanzas")
public class Pago extends BaseEntity {

    @Column(name = "cntas_pagar_id")
    private Long cntasPagarId;

    @Column(name = "banco_cnta_id")
    private Long bancoCntaId;

    @Column(name = "forma_pago_id")
    private Long formaPagoId;

    @Column(nullable = false)
    private LocalDate fecha;

    @Column(nullable = false, precision = 18, scale = 4)
    private BigDecimal monto;

    @Column(length = 120)
    private String referencia;

}
