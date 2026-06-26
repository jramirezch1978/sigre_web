package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorCeseRequest {

    @NotNull(message = "La fecha de cese es obligatoria")
    private LocalDate fechaCese;

    private String motivoCese;
}
