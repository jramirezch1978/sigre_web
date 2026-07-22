package pe.com.sytco.fastsales.Controller.RRHH;

import java.util.List;
import java.util.Map;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.api.rrhh.RrhhApiClient;
import pe.com.sytco.fastsales.api.rrhh.RrhhApiHelper;
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
import pe.com.sytco.fastsales.api.rrhh.dto.TarifarioDto;
import pe.com.sytco.fastsales.api.rrhh.dto.TrabajadorResumenDto;

public class ImplRrhhProduccion extends ImplAncestor {

    public ImplRrhhProduccion(String empresa) throws Exception {
        this.empresaDefault = empresa;
        RrhhApiClient.reset();
        RrhhApiClient.getService(empresa);
    }

    public List<CuadrillaDto> getCuadrillas(String filtro, String usuario) throws Exception {
        return getCuadrillas(filtro, usuario, null, null, null, null, null);
    }

    public List<CuadrillaDto> getCuadrillas(String filtro, String usuario, String otAdm,
            String turno, String especie, String presentacion, String tarea) throws Exception {
        return RrhhApiHelper.unwrapList(
                RrhhApiClient.getService()
                        .getCuadrillas(empresaDefault, query(filtro), query(usuario), query(otAdm),
                                query(turno), query(especie), query(presentacion), query(tarea))
                        .execute(),
                "cuadrillas");
    }

    private static String query(String value) {
        return value != null ? value : "";
    }

    public List<ClienteDto> getClientes(String filtro) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getClientes(empresaDefault, filtro)
                        .execute());
    }

    public ClienteDto getClienteEmpresaDefault() throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getClienteEmpresaDefault(empresaDefault)
                        .execute());
    }

    public List<TarifarioDto> getTarifario(String filtro, String especie,
            String presentacion, String tarea) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getTarifario(empresaDefault, filtro, especie, presentacion, tarea)
                        .execute());
    }

    public List<ParteDestajoConsultaDto> consultarParteDestajo(String fecha,
            String codCuadrilla, String otAdm) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .consultarParteDestajo(empresaDefault, fecha, codCuadrilla, otAdm)
                        .execute());
    }

    public List<CuadrillaLaborDto> getCuadrillaLabores(String codCuadrilla) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getCuadrillaLabores(codCuadrilla, empresaDefault)
                        .execute());
    }

    public List<TrabajadorResumenDto> getCuadrillaTrabajadores(String codCuadrilla) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getCuadrillaTrabajadores(codCuadrilla, empresaDefault)
                        .execute());
    }

    public List<TrabajadorResumenDto> buscarTrabajadores(String texto) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .buscarTrabajadores(empresaDefault, texto)
                        .execute());
    }

    /**
     * Todos los campos de vw_pr_trabajador. Con todos=1 y sin filtros devuelve el listado completo (hasta limite).
     */
    public List<Map<String, Object>> listarTrabajadoresVista(String q, String codigo, String nombre,
            String dni, boolean todos, Integer limite) throws Exception {
        return listarTrabajadoresVista(q, codigo, nombre, dni, todos, limite, null, false);
    }

    public List<Map<String, Object>> listarTrabajadoresVista(String q, String codigo, String nombre,
            String dni, boolean todos, Integer limite, String tipos, boolean soloActivos) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .listarTrabajadores(empresaDefault, q, codigo, nombre, dni,
                                todos ? "1" : null, limite, tipos, soloActivos ? "1" : null)
                        .execute());
    }

    public List<LaborDto> getLabores(String filtro) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getLabores(empresaDefault, filtro)
                        .execute());
    }

    public List<OtAdmDto> getOtAdm(String usuario, String filtro) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getOtAdm(empresaDefault, usuario, filtro)
                        .execute());
    }

    public List<OperacionDto> getOperaciones(String otAdm, String codLabor, String nroOrden, String filtro)
            throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .getOperaciones(empresaDefault, otAdm, codLabor, nroOrden, filtro)
                        .execute());
    }

    public List<JornalCampoResultDto> listarJornalCampo(String fecha, String codTrabajador,
            String codCuadrilla, String otAdm) throws Exception {
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .listarJornalCampo(empresaDefault, fecha, codTrabajador, codCuadrilla, otAdm)
                        .execute());
    }

    public ParteDestajoResultDto guardarParteDestajo(ParteDestajoRequest request) throws Exception {
        request.setEmpresa(empresaDefault);
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .guardarParteDestajo(request)
                        .execute());
    }

    public JornalCampoResultDto guardarJornalCampo(JornalCampoRequest request) throws Exception {
        request.setEmpresa(empresaDefault);
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .guardarJornalCampo(request)
                        .execute());
    }

    public JornalCampoResultDto calcularJornalCampo(JornalCampoRequest request) throws Exception {
        request.setEmpresa(empresaDefault);
        return RrhhApiHelper.unwrap(
                RrhhApiClient.getService()
                        .calcularJornalCampo(request)
                        .execute());
    }
}
