package pe.restaurant.core.service;

import pe.restaurant.core.dto.*;

import java.util.List;
import java.util.Map;

public interface ConfiguracionService {
    List<ConfigClaveResponse> listClaves(String modulo, String nivel, String flagEstado);
    ConfigResolverResult resolver(ConfigResolverRequest request);
    Map<String, Object> getEmpresa(Long empresaId, List<String> claves);
    Map<String, Object> saveEmpresa(ConfigEmpresaSaveRequest request);
    Map<String, Object> getSucursal(Long empresaId, Long sucursalId, List<String> claves);
    Map<String, Object> saveSucursal(ConfigSucursalSaveRequest request);
    Map<String, Object> getUsuario(Long empresaId, Long usuarioId, Long sucursalId, List<String> claves);
    Map<String, Object> saveUsuario(ConfigUsuarioSaveRequest request);
}
