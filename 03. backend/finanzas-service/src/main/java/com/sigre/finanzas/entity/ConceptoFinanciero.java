package com.sigre.finanzas.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import com.sigre.common.entity.BaseConceptoFinanciero;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "concepto_financiero", schema = "finanzas")
public class ConceptoFinanciero extends BaseConceptoFinanciero {
}
