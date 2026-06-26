package pe.restaurant.core.service.impl;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.service.ConfigParameterService;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.Configuracion;
import pe.restaurant.core.entity.ConfiguracionUsuario;
import pe.restaurant.core.repository.ConfiguracionRepository;
import pe.restaurant.core.repository.ConfiguracionUsuarioRepository;
import pe.restaurant.core.repository.SucursalRepository;
import pe.restaurant.core.service.ConfiguracionService;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class ConfiguracionServiceImpl implements ConfiguracionService {
    private static final String PREFIJO_EMPRESA = "EMPRESA";
    private static final String PREFIJO_SUCURSAL = "SUCURSAL";

    private static final String MODULO_GENERAL = "GENERAL";

    private final ConfiguracionRepository configuracionRepository;
    private final ConfiguracionUsuarioRepository configuracionUsuarioRepository;
    private final SucursalRepository sucursalRepository;
    private final JdbcTemplate securityJdbcTemplate;
    private final ConfigParameterService configParameterService;

    public ConfiguracionServiceImpl(
            ConfiguracionRepository configuracionRepository,
            ConfiguracionUsuarioRepository configuracionUsuarioRepository,
            SucursalRepository sucursalRepository,
            @Qualifier("securityJdbcTemplate") JdbcTemplate securityJdbcTemplate,
            ConfigParameterService configParameterService) {
        this.configuracionRepository = configuracionRepository;
        this.configuracionUsuarioRepository = configuracionUsuarioRepository;
        this.sucursalRepository = sucursalRepository;
        this.securityJdbcTemplate = securityJdbcTemplate;
        this.configParameterService = configParameterService;
    }

    @Override
    public List<ConfigClaveResponse> listClaves(String modulo, String nivel, String flagEstado) {
        // config.configuracion: filas activas se consideran vigentes ("1").
        return (modulo == null ? configuracionRepository.findAll() : configuracionRepository.findByModulo(modulo))
                .stream()
                .filter(cfg -> nivel == null || cfg.getParametro().startsWith(nivel.toUpperCase()))
                .filter(cfg -> flagEstado == null || "1".equals(flagEstado))
                .map(cfg -> new ConfigClaveResponse(cfg.getParametro(), cfg.getModulo(), inferNivel(cfg.getParametro()), null, cfg.getTipoDato(), "1"))
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
            ConfigResolverResult sucursal = resolveScopedParameter(
                    buildScopedKey(request.getClave(), PREFIJO_SUCURSAL, context.getSucursalId()), "SUCURSAL");
            if (sucursal != null) {
                return sucursal;
            }
        }
        if (context.getPaisId() != null) {
            ConfigResolverResult pais = resolveScopedParameter(
                    buildScopedKey(request.getClave(), "PAIS", context.getPaisId()), "PAIS");
            if (pais != null) {
                return pais;
            }
        }
        if (context.getEmpresaId() != null) {
            ConfigResolverResult empresa = resolveScopedParameter(
                    buildScopedKey(request.getClave(), PREFIJO_EMPRESA, context.getEmpresaId()), "EMPRESA");
            if (empresa != null) {
                return empresa;
            }
        }
        String defaultValue = configParameterService.getRrhhText(MODULO_GENERAL, request.getClave());
        if (defaultValue == null) {
            defaultValue = configParameterService.getText(request.getClave(), null);
        }
        return new ConfigResolverResult(defaultValue, "EMPRESA");
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
        if (claves != null && !claves.isEmpty()) {
            Map<String, Object> result = new LinkedHashMap<>();
            for (String clave : claves) {
                String parametro = prefix + clave;
                Object value = readParameterValue(parametro);
                if (value != null) {
                    result.put(clave, value);
                }
            }
            return result;
        }
        return configuracionRepository.findAll().stream()
                .filter(cfg -> cfg.getParametro().startsWith(prefix))
                .collect(LinkedHashMap::new,
                        (acc, cfg) -> acc.put(stripScope(cfg.getParametro()), readParameterValue(cfg.getParametro())),
                        Map::putAll);
    }

    private ConfigResolverResult resolveScopedParameter(String parametro, String origenNivel) {
        Object value = readParameterValue(parametro);
        if (value == null) {
            return null;
        }
        return new ConfigResolverResult(value, origenNivel);
    }

    private Object readParameterValue(String parametro) {
        String text = configParameterService.getRrhhText(MODULO_GENERAL, parametro);
        if (text != null) {
            return text;
        }
        Integer entero = configParameterService.getRrhhInt(MODULO_GENERAL, parametro, null);
        if (entero != null) {
            return entero;
        }
        return configParameterService.getRrhhDec(MODULO_GENERAL, parametro, null);
    }

    private void saveScoped(String scope, Long scopeId, Map<String, Object> valores) {
        valores.forEach((clave, valor) -> {
            String scopedKey = buildScopedKey(clave, scope, scopeId);
            Configuracion cfg = configuracionRepository.findByParametro(scopedKey)
                    .orElseGet(Configuracion::new);
            cfg.setModulo("GENERAL");
            cfg.setParametro(scopedKey);
            cfg.setTipoDato("STRING");
            cfg.setValorTexto(valor == null ? null : String.valueOf(valor));
            cfg.setEditable(true);
            cfg.setActivo(true);
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
        if (cfg.getValorBool() != null) {
            return cfg.getValorBool();
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
