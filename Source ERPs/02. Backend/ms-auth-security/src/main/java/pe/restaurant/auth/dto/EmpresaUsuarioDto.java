package pe.restaurant.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EmpresaUsuarioDto {

    private Long empresaId;
    private String codigo;
    private String razonSocial;
    private String ruc;
    private String dbName;
    private String direccionFiscal;
    private Long paisId;
    private Boolean activo;
    private Integer cantidadSucursales;
}
