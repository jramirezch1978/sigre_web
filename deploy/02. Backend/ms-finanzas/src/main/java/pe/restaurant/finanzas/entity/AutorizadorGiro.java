package pe.restaurant.finanzas.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.common.entity.BaseEntity;

@Entity
@Table(name = "autorizador_giro", schema = "finanzas",
        uniqueConstraints = @UniqueConstraint(columnNames = {"centros_costo_id", "usuario_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AutorizadorGiro extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "centros_costo_id", nullable = false)
    private Long centrosCostoId;  // FK diferida a contabilidad.centros_costo

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;  // FK a auth.usuario

    @Column(name = "activo", nullable = false)
    private Boolean activo = true;
}
