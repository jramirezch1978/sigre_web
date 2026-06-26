package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

import java.math.BigDecimal;

@Entity
@Table(name = "af_poliza_activo", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfPolizaActivo extends BaseEntity {

    @Column(name = "af_poliza_seguro_id", nullable = false)
    private Long afPolizaSeguroId;

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "valor_asegurado", precision = 18, scale = 4)
    private BigDecimal valorAsegurado;
}
