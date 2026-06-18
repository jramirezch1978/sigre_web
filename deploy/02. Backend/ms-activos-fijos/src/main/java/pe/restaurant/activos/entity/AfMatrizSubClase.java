package pe.restaurant.activos.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(
        name = "af_matriz_sub_clase",
        schema = "activos",
        uniqueConstraints = @UniqueConstraint(name = "uq_af_matriz_sub_clase_sc", columnNames = "af_sub_clase_id"))
public class AfMatrizSubClase extends BaseEntity {

    @Column(name = "af_sub_clase_id", nullable = false)
    private Long afSubClaseId;

    @Column(name = "cuenta_activo_id")
    private Long cuentaActivoId;

    @Column(name = "cuenta_dep_acum_id")
    private Long cuentaDepAcumId;

    @Column(name = "cuenta_gasto_dep_id")
    private Long cuentaGastoDepId;

    @Column(name = "cuenta_baja_id")
    private Long cuentaBajaId;

    @Column(name = "cuenta_res_venta_id")
    private Long cuentaResVentaId;

    @Column(name = "centro_costo_id")
    private Long centroCostoId;

    @Column(name = "cuenta_gasto_seguro_id")
    private Long cuentaGastoSeguroId;

    @Column(name = "cuenta_pasivo_seguro_id")
    private Long cuentaPasivoSeguroId;

    @Column(name = "cuenta_proveedor_transitoria_id")
    private Long cuentaProveedorTransitoriaId;

    @Column(name = "cuenta_capitalizacion_id")
    private Long cuentaCapitalizacionId;
}
