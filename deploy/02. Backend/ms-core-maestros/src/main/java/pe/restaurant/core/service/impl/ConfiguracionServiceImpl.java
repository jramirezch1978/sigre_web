package pe.restaurant.core.service.impl;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Configuracion;
import pe.restaurant.core.entity.ConfiguracionUsuario;
import pe.restaurant.core.repository.ConfiguracionRepository;
import pe.restaurant.core.repository.ConfiguracionUsuarioRepository;
import pe.restaurant.core.repository.SucursalRepository;
import pe.restaurant.core.service.ConfiguracionService;

import java.util.LinkedHashMap;
import java.util.List;
import pe.restaurant.common.security.TenantContext;
import java.time.Instant;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class ConfiguracionServiceImpl implements ConfiguracionService {
    private static final String PREFIJO_EMPRESA = "EMPRESA";
    private static final String PREFIJO_SUCURSAL = "SUCURSAL";

    private final ConfiguracionRepository configuracionRepository;
    private final ConfiguracionUsuarioRepository configuracionUsuarioRepository;
    private final SucursalRepository sucursalRepository;
    private final JdbcTemplate securityJdbcTemplate;

    public ConfiguracionServiceImpl(
            ConfiguracionRepository configuracionRepository,
            ConfiguracionUsuarioRepository configuracionUsuarioRepository,
            SucursalRepository sucursalRepository,
            @Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate) {
        this.configuracionRepository = configuracionRepository;
        this.configuracionUsuarioRepository = configuracionUsuarioRepository;
        this.sucursalRepository = sucursalRepository;
        this.securityJdbcTemplate = securityJdbcTemplate;
    }

    @Override
    public List<ConfigClaveResponse> listClaves(String modulo, String nivel, String flagEstado) {
        return (modulo == null ? configuracionRepository.findByFlagEstado("1") : configuracionRepository.findByModuloAndFlagEstado(modulo, "1"))
                .stream()
                .filter(cfg -> nivel == null || cfg.getParametro().startsWith(nivel.toUpperCase()))
                .filter(cfg -> flagEstado == null || flagEstado.equals(cfg.getFlagEstado()))
                .map(cfg -> new ConfigClaveResponse(cfg.getParametro(), cfg.getModulo(), inferNivel(cfg.getParametro()), null, cfg.getTipoDato(), cfg.getFlagEstado()))
                .toList();
    }

    @Override
    public ConfigResolverResult resolver(ConfigResolverRequest request) {
        ConfigResolverContext context = request.getContexto() == null ? new ConfigResolverContext() : request.getContexto();
        if (context.getUsuarioId() != null) {
            var user = configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(context.getUsuarioId(), buildScopedKey(request.getClave(), "USUARIO", context.getUsuarioId()), "1");
            if (user.isPresent()) {
                return new ConfigResolverResult(extractValue(user.get()), "USUARIO");
            }
        }
        if (context.getSucursalId() != null) {
            var suc = configuracionRepository.findByParametroAndFlagEstado(buildScopedKey(request.getClave(), PREFIJO_SUCURSAL, context.getSucursalId()), "1");
            if (suc.isPresent()) {
                return new ConfigResolverResult(extractValue(suc.get()), "SUCURSAL");
            }
        }
        if (context.getPaisId() != null) {
            var pais = configuracionRepository.findByParametroAndFlagEstado(buildScopedKey(request.getClave(), "PAIS", context.getPaisId()), "1");
            if (pais.isPresent()) {
                return new ConfigResolverResult(extractValue(pais.get()), "PAIS");
            }
        }
        if (context.getEmpresaId() != null) {
            var emp = configuracionRepository.findByParametroAndFlagEstado(buildScopedKey(request.getClave(), PREFIJO_EMPRESA, context.getEmpresaId()), "1");
            if (emp.isPresent()) {
                return new ConfigResolverResult(extractValue(emp.get()), "EMPRESA");
            }
        }
        var defaultValue = configuracionRepository.findByParametroAndFlagEstado(request.getClave(), "1");
        return new ConfigResolverResult(defaultValue.map(this::extractValue).orElse(null), "EMPRESA");
    }

    @Override
    public Map<String, Object> getEmpresa(Long empresaId, List<String> claves) {
        return getScoped(PREFIJO_EMPRESA, empresaId, claves);
    }

    @Override
    @Transactional
    public Map<String, Object> saveEmpresa(ConfigEmpresaSaveRequest request) {
        validateEmpresaExists(request.getEmpresaId());
        saveScoped(PREFIJO_EMPRESA, request.getEmpresaId(), request.getValores());
        return getEmpresa(request.getEmpresaId(), null);
    }

    @Override
    public Map<String, Object> getSucursal(Long empresaId, Long sucursalId, List<String> claves) {
        return getScoped(PREFIJO_SUCURSAL, sucursalId, claves);
    }

    @Override
    @Transactional
    public Map<String, Object> saveSucursal(ConfigSucursalSaveRequest request) {
        validateSucursalExists(request.getSucursalId());
        saveScoped(PREFIJO_SUCURSAL, request.getSucursalId(), request.getValores());
        return getSucursal(request.getEmpresaId(), request.getSucursalId(), null);
    }

    @Override
    public Map<String, Object> getUsuario(Long empresaId, Long usuarioId, Long sucursalId, List<String> claves) {
        return configuracionUsuarioRepository.findByUsuarioIdAndFlagEstado(usuarioId, "1").stream()
                .filter(cfg -> claves == null || claves.isEmpty() || claves.stream().anyMatch(key -> cfg.getParametro().contains(key)))
                .collect(LinkedHashMap::new, (acc, cfg) -> acc.put(stripScope(cfg.getParametro()), extractValue(cfg)), Map::putAll);
    }

    @Override
    @Transactional
    public Map<String, Object> saveUsuario(ConfigUsuarioSaveRequest request) {
        validateUsuarioExists(request.getUsuarioId());
        request.getValores().forEach((clave, valor) -> {
            String scopedKey = buildScopedKey(clave, "USUARIO", request.getUsuarioId());
            ConfiguracionUsuario cfg = configuracionUsuarioRepository.findByUsuarioIdAndParametroAndFlagEstado(request.getUsuarioId(), scopedKey, "1")
                    .orElseGet(ConfiguracionUsuario::new);
            cfg.setUsuarioId(request.getUsuarioId());
            cfg.setModulo("GENERAL");
            cfg.setParametro(scopedKey);
            cfg.setTipoDato("STRING");
            cfg.setValorTexto(valor == null ? null : String.valueOf(valor));
            cfg.setFlagEstado("1");
            configuracionUsuarioRepository.save(cfg);
        });
        return getUsuario(request.getEmpresaId(), request.getUsuarioId(), request.getSucursalId(), null);
    }

    private Map<String, Object> getScoped(String scope, Long scopeId, List<String> claves) {
        String prefix = scope + "_" + scopeId + "_";
        return configuracionRepository.findByFlagEstado("1").stream()
                .filter(cfg -> cfg.getParametro().startsWith(prefix))
                .filter(cfg -> claves == null || claves.isEmpty() || claves.contains(stripScope(cfg.getParametro())))
                .collect(LinkedHashMap::new, (acc, cfg) -> acc.put(stripScope(cfg.getParametro()), extractValue(cfg)), Map::putAll);
    }

    private void saveScoped(String scope, Long scopeId, Map<String, Object> valores) {
        valores.forEach((clave, valor) -> {
            String scopedKey = buildScopedKey(clave, scope, scopeId);
            Configuracion cfg = configuracionRepository.findByParametroAndFlagEstado(scopedKey, "1")
                    .orElseGet(Configuracion::new);
            cfg.setModulo("GENERAL");
            cfg.setParametro(scopedKey);
            cfg.setTipoDato("STRING");
            cfg.setValorTexto(valor == null ? null : String.valueOf(valor));
            cfg.setEditable(true);
            cfg.setFlagEstado("1");
            configuracionRepository.save(cfg);
        });
    }

    private String buildScopedKey(String clave, String nivel, Long id) {
        return nivel + "_" + id + "_" + clave;
    }

    private String stripScope(String parametro) {
        int pos = parametro.indexOf('_');
        if (pos < 0) {
            return parametro;
        }
        int second = parametro.indexOf('_', pos + 1);
        return second < 0 ? parametro : parametro.substring(second + 1);
    }

    private String inferNivel(String parametro) {
        if (parametro.startsWith("USUARIO_")) {
            return "USUARIO";
        }
        if (parametro.startsWith("SUCURSAL_")) {
            return "SUCURSAL";
        }
        if (parametro.startsWith("PAIS_")) {
            return "PAIS";
        }
        if (parametro.startsWith("EMPRESA_")) {
            return "EMPRESA";
        }
        return "EMPRESA";
    }

    private Object extractValue(Configuracion cfg) {
        if (cfg.getValorTexto() != null) {
            return cfg.getValorTexto();
        }
        if (cfg.getValorEntero() != null) {
            return cfg.getValorEntero();
        }
        if (cfg.getValorDecimal() != null) {
            return cfg.getValorDecimal();
        }
        if (cfg.getValorFecha() != null) {
            return cfg.getValorFecha();
        }
        return null;
    }

    private Object extractValue(ConfiguracionUsuario cfg) {
        if (cfg.getValorTexto() != null) {
            return cfg.getValorTexto();
        }
        if (cfg.getValorEntero() != null) {
            return cfg.getValorEntero();
        }
        if (cfg.getValorDecimal() != null) {
            return cfg.getValorDecimal();
        }
        if (cfg.getValorFecha() != null) {
            return cfg.getValorFecha();
        }
        return null;
    }

    private void validateEmpresaExists(Long empresaId) {
        Integer count = securityJdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM master.empresa WHERE id = ?", Integer.class, empresaId);
        if (count == null || count == 0) {
            throw new ResourceNotFoundException("Empresa", empresaId);
        }
    }

    private void validateSucursalExists(Long sucursalId) {
        if (!sucursalRepository.existsById(sucursalId)) {
            throw new ResourceNotFoundException("Sucursal", sucursalId);
        }
    }

    private void validateUsuarioExists(Long usuarioId) {
        Integer count = securityJdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario WHERE id = ?", Integer.class, usuarioId);
        if (count == null || count == 0) {
            throw new ResourceNotFoundException("Usuario", usuarioId);
        }
    }
}
