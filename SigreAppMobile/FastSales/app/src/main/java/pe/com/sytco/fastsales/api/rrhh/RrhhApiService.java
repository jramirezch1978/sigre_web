package pe.com.sytco.fastsales.api.rrhh;

import java.util.List;
import java.util.Map;

import pe.com.sytco.fastsales.api.rrhh.dto.ClienteDto;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaDto;
import pe.com.sytco.fastsales.api.rrhh.dto.CuadrillaLaborDto;
import pe.com.sytco.fastsales.api.rrhh.dto.JornalCampoRequest;
import pe.com.sytco.fastsales.api.rrhh.dto.JornalCampoResultDto;
import pe.com.sytco.fastsales.api.rrhh.dto.LaborDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OperacionDto;
import pe.com.sytco.fastsales.api.rrhh.dto.OtAdmDto;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoConsultaDto;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoRequest;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoResultDto;
import pe.com.sytco.fastsales.api.rrhh.dto.RestResponse;
import pe.com.sytco.fastsales.api.rrhh.dto.TarifarioDto;
import pe.com.sytco.fastsales.api.rrhh.dto.TrabajadorResumenDto;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface RrhhApiService {

    @GET("SigreWebService/api/rrhh/catalogos/cuadrillas")
    Call<RestResponse<List<CuadrillaDto>>> getCuadrillas(
            @Query("empresa") String empresa,
            @Query("filtro") String filtro,
            @Query("usuario") String usuario,
            @Query("otAdm") String otAdm,
            @Query("turno") String turno,
            @Query("especie") String especie,
            @Query("presentacion") String presentacion,
            @Query("tarea") String tarea);

    @GET("SigreWebService/api/rrhh/catalogos/clientes")
    Call<RestResponse<List<ClienteDto>>> getClientes(
            @Query("empresa") String empresa,
            @Query("filtro") String filtro);

    @GET("SigreWebService/api/rrhh/catalogos/clientes/default")
    Call<RestResponse<ClienteDto>> getClienteEmpresaDefault(
            @Query("empresa") String empresa);

    @GET("SigreWebService/api/rrhh/catalogos/tarifario")
    Call<RestResponse<List<TarifarioDto>>> getTarifario(
            @Query("empresa") String empresa,
            @Query("filtro") String filtro,
            @Query("especie") String especie,
            @Query("presentacion") String presentacion,
            @Query("tarea") String tarea);

    @GET("SigreWebService/api/rrhh/parte-destajo")
    Call<RestResponse<List<ParteDestajoConsultaDto>>> consultarParteDestajo(
            @Query("empresa") String empresa,
            @Query("fecha") String fecha,
            @Query("codCuadrilla") String codCuadrilla,
            @Query("otAdm") String otAdm);

    @GET("SigreWebService/api/rrhh/catalogos/cuadrillas/{cod}/labores")
    Call<RestResponse<List<CuadrillaLaborDto>>> getCuadrillaLabores(
            @Path("cod") String codCuadrilla,
            @Query("empresa") String empresa);

    @GET("SigreWebService/api/rrhh/catalogos/cuadrillas/{cod}/trabajadores")
    Call<RestResponse<List<TrabajadorResumenDto>>> getCuadrillaTrabajadores(
            @Path("cod") String codCuadrilla,
            @Query("empresa") String empresa);

    @GET("SigreWebService/api/rrhh/catalogos/labores")
    Call<RestResponse<List<LaborDto>>> getLabores(
            @Query("empresa") String empresa,
            @Query("filtro") String filtro);

    @GET("SigreWebService/api/rrhh/catalogos/ot-adm")
    Call<RestResponse<List<OtAdmDto>>> getOtAdm(
            @Query("empresa") String empresa,
            @Query("usuario") String usuario,
            @Query("filtro") String filtro);

    @GET("SigreWebService/api/rrhh/catalogos/operaciones")
    Call<RestResponse<List<OperacionDto>>> getOperaciones(
            @Query("empresa") String empresa,
            @Query("otAdm") String otAdm,
            @Query("codLabor") String codLabor,
            @Query("nroOrden") String nroOrden,
            @Query("filtro") String filtro);

    @GET("SigreWebService/api/rrhh/trabajadores")
    Call<RestResponse<List<Map<String, Object>>>> listarTrabajadores(
            @Query("empresa") String empresa,
            @Query("q") String q,
            @Query("codigo") String codigo,
            @Query("nombre") String nombre,
            @Query("dni") String dni,
            @Query("todos") String todos,
            @Query("limite") Integer limite,
            @Query("tipos") String tipos,
            @Query("soloActivos") String soloActivos);

    @GET("SigreWebService/api/rrhh/trabajadores/buscar")
    Call<RestResponse<List<TrabajadorResumenDto>>> buscarTrabajadores(
            @Query("empresa") String empresa,
            @Query("q") String texto);

    @GET("SigreWebService/api/rrhh/jornal-campo")
    Call<RestResponse<List<JornalCampoResultDto>>> listarJornalCampo(
            @Query("empresa") String empresa,
            @Query("fecha") String fecha,
            @Query("codTrabajador") String codTrabajador,
            @Query("codCuadrilla") String codCuadrilla,
            @Query("otAdm") String otAdm);

    @POST("SigreWebService/api/rrhh/parte-destajo")
    Call<RestResponse<ParteDestajoResultDto>> guardarParteDestajo(@Body ParteDestajoRequest request);

    @POST("SigreWebService/api/rrhh/jornal-campo")
    Call<RestResponse<JornalCampoResultDto>> guardarJornalCampo(@Body JornalCampoRequest request);

    @POST("SigreWebService/api/rrhh/jornal-campo/calcular")
    Call<RestResponse<JornalCampoResultDto>> calcularJornalCampo(@Body JornalCampoRequest request);
}
