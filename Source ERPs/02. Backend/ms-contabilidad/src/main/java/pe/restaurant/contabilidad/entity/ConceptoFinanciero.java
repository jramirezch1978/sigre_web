package pe.restaurant.contabilidad.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pe.restaurant.common.entity.BaseConceptoFinanciero;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "concepto_financiero", schema = "finanzas")
public class ConceptoFinanciero extends BaseConceptoFinanciero {
}
