package com.sigre.seguridad.dto;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * Petición de recreación de tenant(s). Compatible hacia atrás:
 * - {@code dbName} como string único → recrea una BD (response objeto, igual que antes).
 * - {@code dbName} como arreglo → recrea cada BD (response arreglo).
 * - o identificar UNA empresa por {@code empresaId}/{@code codigo}/{@code ruc}.
 */
@Data
public class RecreateEmpresaBatchRequest {

    @Positive(message = "empresaId debe ser positivo")
    private Long empresaId;

    @Size(max = 20)
    private String codigo;

    @Size(max = 20)
    private String ruc;

    /** Acepta string único o arreglo (alias JSON {@code nombre}). */
    @JsonAlias({"nombre"})
    @JsonDeserialize(using = StringOrListDeserializer.class)
    private List<String> dbName = new ArrayList<>();
}
