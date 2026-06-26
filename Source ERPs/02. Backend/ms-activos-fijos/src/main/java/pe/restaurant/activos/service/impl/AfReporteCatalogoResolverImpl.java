package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;
import pe.restaurant.activos.service.AfReporteCatalogoResolver;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class AfReporteCatalogoResolverImpl implements AfReporteCatalogoResolver {

    private final AfSubClaseRepository subClaseRepository;
    private final AfClaseRepository claseRepository;
    private final AfUbicacionRepository ubicacionRepository;
    private final JdbcTemplate jdbcTemplate;
    private final IntegracionProperties integracionProperties;

    @Override
    public Optional<AfSubClase> subClase(Long id) {
        return id == null ? Optional.empty() : subClaseRepository.findById(id);
    }

    @Override
    public Optional<AfClase> clase(Long id) {
        return id == null ? Optional.empty() : claseRepository.findById(id);
    }

    @Override
    public Optional<AfUbicacion> ubicacion(Long id) {
        return id == null ? Optional.empty() : ubicacionRepository.findById(id);
    }

    @Override
    public String centroCostoEtiqueta(Long centroCostoId) {
        if (centroCostoId == null) {
            return "";
        }
        return etiquetasCentroCosto(Set.of(centroCostoId)).getOrDefault(centroCostoId, String.valueOf(centroCostoId));
    }

    @Override
    public String monedaDefecto() {
        Long monedaId = integracionProperties.getContabilidad().getMonedaId();
        if (monedaId == null) {
            return "PEN";
        }
        try {
            return jdbcTemplate.queryForObject(
                    "SELECT COALESCE(codigo, sigla_moneda, simbolo, 'PEN') FROM core.moneda WHERE id = ?",
                    String.class,
                    monedaId);
        } catch (Exception e) {
            return "PEN";
        }
    }

    @Override
    public Map<Long, String> etiquetasCentroCosto(Iterable<Long> ids) {
        Set<Long> unicos = new HashSet<>();
        for (Long id : ids) {
            if (id != null) {
                unicos.add(id);
            }
        }
        Map<Long, String> out = new HashMap<>();
        for (Long id : unicos) {
            try {
                String etiqueta = jdbcTemplate.queryForObject(
                        "SELECT cencos || ' — ' || desc_cencos FROM contabilidad.centros_costo WHERE id = ?",
                        String.class,
                        id);
                out.put(id, etiqueta);
            } catch (Exception e) {
                out.put(id, String.valueOf(id));
            }
        }
        return out;
    }
}
