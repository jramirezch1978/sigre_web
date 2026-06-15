package com.sigre.auth.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Identificar la empresa con <strong>uno</strong> de: {@code empresaId}, {@code codigo}, {@code ruc},
 * o nombre físico de la BD tenant ({@code dbName}, alias JSON {@code nombre}).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecreateEmpresaRequest {

    /** Si se envía, tiene prioridad sobre codigo/ruc/dbName. */
    @Positive(message = "empresaId debe ser positivo")
    private Long empresaId;

    @Size(max = 20)
    private String codigo;

    @Size(max = 20)
    private String ruc;

    /** Nombre de la base PostgreSQL del tenant (ej. {@code sigre_emp_cantabria}). */
    @Size(max = 120)
    @JsonAlias({"nombre"})
    private String dbName;
}
