package pe.restaurant.contabilidad.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
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
@Table(name = "uit", schema = "core",
        uniqueConstraints = @UniqueConstraint(name = "UQ_UIT_ANO_VIGEN", columnNames = {"ano", "fec_ini_vigen"}))
public class Uit extends BaseEntity {

    @Column(nullable = false)
    private Integer ano;

    @Column(name = "fec_ini_vigen", nullable = false)
    private LocalDate fecIniVigen;

    @Column(nullable = false, precision = 13, scale = 2)
    private BigDecimal importe = BigDecimal.ZERO;
}
