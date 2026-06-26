package pe.restaurant.core.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * Lectura del plan contable detalle (`contabilidad.plan_contable_det`) desde core.
 * Mapeo MÍNIMO (solo columnas que existen en todos los tenants) para evitar el
 * schema-drift de tenants migrados (p. ej. Cantabria no tiene abrev_cnta/naturaleza/tipo).
 */
@Getter
@Setter
@Entity
@Table(name = "plan_contable_det", schema = "contabilidad")
public class PlanContableDet {

    @Id
    private Long id;

    @Column(name = "cnta_ctbl")
    private String cntaCtbl;

    @Column(name = "desc_cnta")
    private String descCnta;

    @Column(name = "flag_estado")
    private String flagEstado;
}
