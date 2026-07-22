package pe.com.hermes.appmobile.data.remote.dto;

import com.google.gson.annotations.SerializedName;

/** Espejo de com.sigre.seguridad.dto.EmpresaUsuarioDto. */
public class EmpresaUsuarioDto {
    @SerializedName(value = "empresaId", alternate = {"id"})
    public long empresaId;
    public String codigo;
    public String razonSocial;
    public String ruc;
    public String dbName;
}
