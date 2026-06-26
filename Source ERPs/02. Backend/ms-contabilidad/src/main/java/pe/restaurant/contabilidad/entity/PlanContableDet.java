package pe.restaurant.contabilidad.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseEntity;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "plan_contable_det", schema = "contabilidad")
public class PlanContableDet extends BaseEntity {

    @Column(name = "plan_contable_id", nullable = false)
    private Long planContableId;

    @Column(name = "cnta_ctbl", length = 10, nullable = false)
    private String cntaCtbl;

    @Column(name = "desc_cnta", length = 200, nullable = false)
    private String descCnta;

    @Column(name = "niv_cnta", nullable = false)
    private Integer nivCnta = 1;

    @Column(name = "flag_cencos", nullable = false, length = 1)
    private String flagCencos = "0";

    @Column(name = "flag_cod_relacion", nullable = false, length = 1)
    private String flagCodRelacion = "0";

    @Column(name = "flag_doc_ref", nullable = false, length = 1)
    private String flagDocRef = "0";

    @Column(name = "flag_permite_mov", nullable = false, length = 1)
    private String flagPermiteMov = "0";

    @Column(name = "flag_ctabco", nullable = false, length = 1)
    private String flagCtabco = "0";

    @Column(name = "flag_tipo_saldo", nullable = false, length = 1)
    private String flagTipoSaldo = "D";

    @Column(name = "cnta_cntbl_sunat", length = 10)
    private String cntaCntblSunat;
}
