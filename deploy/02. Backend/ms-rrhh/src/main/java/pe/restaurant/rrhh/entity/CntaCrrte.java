package pe.restaurant.rrhh.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data @EqualsAndHashCode(callSuper = true)
@NoArgsConstructor @AllArgsConstructor
@Entity @Table(name = "cnta_crrte", schema = "rrhh")
public class CntaCrrte extends BaseEntity {

    @Column(name = "trabajador_id", nullable = false) private Long trabajadorId;
    @Column(name = "fecha_apertura") private LocalDate fechaApertura;
    @Column(name = "saldo_inicial", precision = 18, scale = 4) private BigDecimal saldoInicial;
    @Column(name = "saldo_actual", precision = 18, scale = 4) private BigDecimal saldoActual;
}
