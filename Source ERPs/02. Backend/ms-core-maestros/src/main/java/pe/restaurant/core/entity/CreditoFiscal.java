package pe.restaurant.core.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "credito_fiscal", schema = "core")
public class CreditoFiscal extends BaseEntity {

    @Column(name = "codigo", nullable = false, unique = true, columnDefinition = "char(2)")
    private String codigo;

    @Column(name = "descripcion", length = 50)
    private String descripcion;

    @Column(name = "cod_sunat", columnDefinition = "char(2)")
    private String codSunat;

    @Column(name = "flag_tipo_adquisicion", nullable = false, columnDefinition = "char(1)")
    private String flagTipoAdquisicion = "3";

    @Column(name = "flag_cxp_cxc", nullable = false, columnDefinition = "char(1)")
    private String flagCxpCxc = "P";

    @Column(name = "tipo_afectacion_igv", columnDefinition = "char(2)")
    private String tipoAfectacionIgv;
}
