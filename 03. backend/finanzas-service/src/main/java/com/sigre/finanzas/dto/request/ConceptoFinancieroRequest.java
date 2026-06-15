package com.sigre.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConceptoFinancieroRequest {

    @NotBlank
    @Size(max = 20)
    private String codigo;

    @NotBlank
    @Size(max = 150)
    private String nombre;

    // Obligatorio: la tabla concepto_financiero exige matriz_contable_id (NOT NULL + FK).
    @NotNull
    private Long matrizContableId;

    @Size(max = 1)
    private String flagEstado;
}
