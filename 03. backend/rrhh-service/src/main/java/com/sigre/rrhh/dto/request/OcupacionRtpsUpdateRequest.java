package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class OcupacionRtpsUpdateRequest {
    @NotBlank @Size(max = 200) private String nombre;
}
