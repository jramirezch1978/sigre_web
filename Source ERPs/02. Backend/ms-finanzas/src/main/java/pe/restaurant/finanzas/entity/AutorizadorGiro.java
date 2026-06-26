package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "autorizador_giro", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(columnNames = {"centros_costo_id", "usuario_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = false)
public class AutorizadorGiro extends BaseEntity {

    @Column(name = "centros_costo_id", nullable = false)
    private Long centrosCostoId;  // FK diferida a contabilidad.centros_costo

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;  // FK a auth.usuario

    @Column(name = "activo", nullable = false)
    private Boolean activo = true;
}
