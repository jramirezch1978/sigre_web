package pe.restaurant.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.restaurant.finanzas.enums.TipoNota;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotaRequest {

    @NotNull(message = "El tipo de nota es requerido")
    private TipoNota tipoNota;

    @NotNull(message = "El proveedor es requerido")
    private Long proveedorId;

    @NotNull(message = "El tipo de documento es requerido")
    private Long docTipoId;

    private String serie;

    private String numero;

    @NotNull(message = "La fecha de emisión es requerida")
    private LocalDate fechaEmision;

    private LocalDate fechaVencimiento;

    @NotNull(message = "La moneda es requerida")
    private Long monedaId;

    @NotNull(message = "El total es requerido")
    @Positive(message = "El total debe ser mayor que 0")
    private BigDecimal total;

    private String descripcion;

    private Long formaPagoId;

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

    private String codOrigen;

    private String operDetr;

    private Long detrBienServId;

    private String nroDetraccion;

    private String flagDetraccion;

    private BigDecimal importeDetraccion;

    private String flagRetencion;

    private BigDecimal porcRetIgv;

    @Valid
    @NotNull(message = "Los detalles son requeridos")
    private List<NotaDetalleRequest> detalles;
}
