package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "af_poliza_seguro", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfPolizaSeguro extends BaseEntity {

    @Column(name = "af_aseguradora_id", nullable = false)
    private Long afAseguradoraId;

    @Column(name = "numero_poliza", nullable = false, unique = true, length = 30)
    private String numeroPoliza;

    @Column(name = "fecha_inicio", nullable = false)
    private LocalDate fechaInicio;

    @Column(name = "fecha_fin")
    private LocalDate fechaFin;

    @Column(precision = 18, scale = 4)
    private BigDecimal prima;

    @Column(precision = 18, scale = 4)
    private BigDecimal cobertura;

}
