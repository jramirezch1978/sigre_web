package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "uit", schema = "core")
public class Uit extends BaseEntity {

    @Column(name = "ano", nullable = false)
    private Integer ano;

    @Column(name = "importe", nullable = false, precision = 13, scale = 2)
    private BigDecimal importe = BigDecimal.ZERO;

    @Column(name = "fec_ini_vigen", nullable = false)
    private LocalDate fecIniVigen;
}
