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
@Table(name = "af_adaptacion", schema = "activos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class AfAdaptacion extends BaseEntity {

    @Column(name = "af_maestro_id", nullable = false)
    private Long afMaestroId;

    @Column(name = "fecha", nullable = false)
    private LocalDate fecha;

    @Column(name = "descripcion", nullable = false, length = 300)
    private String descripcion;

    @Column(name = "monto_total", precision = 18, scale = 4, nullable = false)
    private BigDecimal montoTotal;

    @Column(name = "cntbl_asiento_id")
    private Long cntblAsientoId;

    @Column(name = "estado", nullable = false, length = 20)
    private String estado = "REGISTRADO";

}
