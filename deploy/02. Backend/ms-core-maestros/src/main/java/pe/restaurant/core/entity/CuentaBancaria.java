package pe.restaurant.core.entity;

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
@Table(name = "entidad_banco_cnta", schema = "core")
public class CuentaBancaria extends BaseEntity {

    @ManyToOne(optional = false)
    @JoinColumn(name = "entidad_contribuyente_id")
    private RelacionComercial relacionComercial;

    @Column(name = "cod_banco", length = 3)
    private String codBanco;

    @Column(name = "moneda_id")
    private Long monedaId;

    @Column(name = "nro_cuenta", nullable = false, length = 60)
    private String numeroCuenta;

    @Column(name = "cci", length = 60)
    private String cci;
}
