package pe.restaurant.ventas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
public class FacturaSimplCabeceraRequest {

    private Long sucursalId;

    private Long puntoVentaId;

    @NotNull
    private Long clienteId;

    @NotNull
    private Long docTipoId;

    @NotBlank
    private String serie;

    @NotBlank
    private String numero;

    @NotNull
    private LocalDate fechaEmision;

    private Long monedaId;

    @NotNull(message = "El año del periodo contable es obligatorio")
    @Min(value = 1900, message = "El año debe ser válido")
    private Integer ano;

    @NotNull(message = "El mes del periodo contable es obligatorio")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    @NotNull(message = "El libro contable (cntbl_libro_id) es obligatorio")
    @Positive(message = "El libro contable debe ser un id válido")
    private Long cntblLibroId;

    @NotNull
    @NotEmpty
    @Valid
    private List<FacturaSimplLineRequest> items;

    @Valid
    private List<FacturaSimplPagoRequest> pagos;
}
