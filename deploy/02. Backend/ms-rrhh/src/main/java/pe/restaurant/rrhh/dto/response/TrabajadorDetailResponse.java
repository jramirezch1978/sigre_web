package pe.restaurant.rrhh.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TrabajadorDetailResponse {
    private Long id;
    private RefResponse entidadContribuyente;
    private String codigoTrabajador;
    private String nombres;
    private String apellidoPaterno;
    private String apellidoMaterno;
    private RefResponse tipoDocIdentidad;
    private String numeroDocumento;
    private String fechaNacimiento;
    private RefResponse sexo;
    private RefResponse estadoCivil;
    private String direccion;
    private String telefono;
    private String email;
    private String cuentaBancariaSueldo;
    private String cuentaCts;
    private RefResponse adminAfp;
    private String cuspp;
    private RefResponse regimenLaboral;
    private RefResponse area;
    private RefResponse cargo;
    private RefResponse sucursal;
    private String fechaIngreso;
    private String fechaCese;
    private String motivoCese;
    private String flagEstado;
    private Long createdBy;
    private String fecCreacion;
    private Long updatedBy;
    private String fecModificacion;
    private List<ContratoResponse> contratos;
    private List<HorarioResponse> horarios;
}
