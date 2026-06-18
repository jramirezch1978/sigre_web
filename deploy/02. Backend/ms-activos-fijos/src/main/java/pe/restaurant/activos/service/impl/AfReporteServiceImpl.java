package pe.restaurant.activos.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.dto.reporte.AfReporteDepreciacionAnualResponse;
import pe.restaurant.activos.dto.reporte.AfReporteDepreciacionMensualResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroLineaResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.service.AfReporteCatalogoResolver;
import pe.restaurant.activos.service.AfReporteService;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfReporteServiceImpl implements AfReporteService {

    private final AfMaestroRepository maestroRepository;
    private final AfCalculoCntblRepository calculoRepository;
    private final AfMatrizSubClaseRepository matrizRepository;
    private final AfSubClaseRepository subClaseRepository;
    private final AfReporteCatalogoResolver catalogoResolver;

    @Override
    public AfReporteLibroResponse libroActivos(LocalDate fechaCorte, Long afSubClaseId, Long afUbicacionId,
                                               String flagEstado, String estadoActivo,
                                               BigDecimal valorMin, BigDecimal valorMax) {
        LocalDate corte = fechaCorte != null ? fechaCorte : LocalDate.now();
        List<AfMaestro> activos = maestroRepository.findAll();
        List<AfReporteLibroLineaResponse> lineas = new ArrayList<>();
        BigDecimal tAdq = BigDecimal.ZERO;
        BigDecimal tDep = BigDecimal.ZERO;
        BigDecimal tNeto = BigDecimal.ZERO;
        String monedaDefecto = catalogoResolver.monedaDefecto();
        Set<Long> ccIds = new HashSet<>();

        for (AfMaestro m : activos) {
            if (!pasaFiltro(m, afSubClaseId, afUbicacionId, flagEstado, estadoActivo, valorMin, valorMax, null)) {
                continue;
            }
            AfReporteLibroLineaResponse linea = buildLinea(m, corte, monedaDefecto, ccIds);
            lineas.add(linea);
            tAdq = tAdq.add(linea.getValorAdquisicion());
            tDep = tDep.add(linea.getDepreciacionAcumulada());
            tNeto = tNeto.add(linea.getValorNeto());
        }
        Map<Long, String> ccEtiquetas = catalogoResolver.etiquetasCentroCosto(ccIds);
        for (AfReporteLibroLineaResponse linea : lineas) {
            if (linea.getCentroCostoId() != null) {
                linea.setCentroCosto(ccEtiquetas.getOrDefault(linea.getCentroCostoId(), String.valueOf(linea.getCentroCostoId())));
            }
        }
        lineas.sort(Comparator.comparing(AfReporteLibroLineaResponse::getCodigo));

        AfReporteLibroResponse report = new AfReporteLibroResponse();
        report.setFechaCorte(corte);
        report.setLineas(lineas);
        report.setTotalValorAdquisicion(tAdq);
        report.setTotalDepreciacionAcumulada(tDep);
        report.setTotalValorNeto(tNeto);
        return report;
    }

    @Override
    public AfReporteDepreciacionAnualResponse depreciacionAnual(Long afMaestroId, Integer anio) {
        AfMaestro m = maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> new ResourceNotFoundException("Activo", afMaestroId));
        List<AfCalculoCntbl> delAnio = calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(afMaestroId)
                .stream()
                .filter(c -> c.getAnio().equals(anio))
                .sorted(Comparator.comparing(AfCalculoCntbl::getMes))
                .toList();

        BigDecimal totalAnual = delAnio.stream()
                .map(AfCalculoCntbl::getDepreciacionPeriodo)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        AfCalculoCntbl ultimo = delAnio.isEmpty()
                ? calculoRepository.obtenerUltimaDepreciacion(afMaestroId).orElse(null)
                : delAnio.get(delAnio.size() - 1);

        AfReporteDepreciacionAnualResponse r = new AfReporteDepreciacionAnualResponse();
        r.setAfMaestroId(afMaestroId);
        r.setCodigoActivo(m.getCodigo());
        r.setAnio(anio);
        r.setValorAdquisicion(m.getValorAdquisicion());
        r.setValorResidual(m.getValorResidual());
        r.setTotalDepreciacionAnual(totalAnual);
        if (ultimo != null) {
            r.setDepreciacionAcumuladaFinAnio(ultimo.getDepreciacionAcumulada());
            r.setValorNetoFinAnio(ultimo.getValorNeto());
        } else {
            r.setDepreciacionAcumuladaFinAnio(BigDecimal.ZERO);
            r.setValorNetoFinAnio(m.getValorAdquisicion());
        }
        r.setMeses(delAnio.stream().map(c -> {
            AfReporteDepreciacionMensualResponse mr = new AfReporteDepreciacionMensualResponse();
            mr.setMes(c.getMes());
            mr.setDepreciacionPeriodo(c.getDepreciacionPeriodo());
            mr.setDepreciacionAcumulada(c.getDepreciacionAcumulada());
            mr.setValorNeto(c.getValorNeto());
            mr.setCalculoId(c.getId());
            return mr;
        }).toList());
        return r;
    }

    @Override
    public AfReporteLibroResponse consolidado(LocalDate fechaCorte, Long afClaseId) {
        List<Long> subClaseIds = null;
        if (afClaseId != null) {
            subClaseIds = subClaseRepository.findAll().stream()
                    .filter(s -> afClaseId.equals(s.getAfClaseId()))
                    .map(AfSubClase::getId)
                    .toList();
        }
        LocalDate corte = fechaCorte != null ? fechaCorte : LocalDate.now();
        AfReporteLibroResponse base = new AfReporteLibroResponse();
        base.setFechaCorte(corte);
        base.setLineas(new ArrayList<>());
        base.setTotalValorAdquisicion(BigDecimal.ZERO);
        base.setTotalDepreciacionAcumulada(BigDecimal.ZERO);
        base.setTotalValorNeto(BigDecimal.ZERO);

        String monedaDefecto = catalogoResolver.monedaDefecto();
        Set<Long> ccIds = new HashSet<>();
        for (AfMaestro m : maestroRepository.findAll()) {
            if (subClaseIds != null && !subClaseIds.contains(m.getAfSubClaseId())) {
                continue;
            }
            AfReporteLibroLineaResponse linea = buildLinea(m, corte, monedaDefecto, ccIds);
            base.getLineas().add(linea);
            base.setTotalValorAdquisicion(base.getTotalValorAdquisicion().add(linea.getValorAdquisicion()));
            base.setTotalDepreciacionAcumulada(
                    base.getTotalDepreciacionAcumulada().add(linea.getDepreciacionAcumulada()));
            base.setTotalValorNeto(base.getTotalValorNeto().add(linea.getValorNeto()));
        }
        Map<Long, String> ccEtiquetas = catalogoResolver.etiquetasCentroCosto(ccIds);
        for (AfReporteLibroLineaResponse linea : base.getLineas()) {
            if (linea.getCentroCostoId() != null) {
                linea.setCentroCosto(ccEtiquetas.getOrDefault(linea.getCentroCostoId(), String.valueOf(linea.getCentroCostoId())));
            }
        }
        return base;
    }

    private AfReporteLibroLineaResponse buildLinea(AfMaestro m, LocalDate fechaCorte, String monedaDefecto, Set<Long> ccIds) {
        int anioCorte = fechaCorte.getYear();
        int mesCorte = fechaCorte.getMonthValue();
        List<AfCalculoCntbl> historial = calculoRepository.findByAfMaestroIdOrderByAnioDescMesDesc(m.getId());
        Optional<AfCalculoCntbl> calc = historial.stream()
                .filter(c -> c.getAnio() < anioCorte
                        || (c.getAnio().equals(anioCorte) && c.getMes() <= mesCorte))
                .findFirst();

        BigDecimal depAcum = calc.map(AfCalculoCntbl::getDepreciacionAcumulada).orElse(BigDecimal.ZERO);
        BigDecimal valorNeto = calc.map(AfCalculoCntbl::getValorNeto)
                .orElse(m.getValorAdquisicion());

        Long cc = matrizRepository.findByAfSubClaseId(m.getAfSubClaseId())
                .map(AfMatrizSubClase::getCentroCostoId)
                .orElse(null);
        if (cc != null) {
            ccIds.add(cc);
        }

        LocalDate fechaInicioDep = historial.stream()
                .min(Comparator.comparing(AfCalculoCntbl::getAnio).thenComparing(AfCalculoCntbl::getMes))
                .map(c -> LocalDate.of(c.getAnio(), c.getMes(), 1))
                .orElse(m.getFechaAdquisicion());

        AfReporteLibroLineaResponse linea = new AfReporteLibroLineaResponse();
        linea.setAfMaestroId(m.getId());
        linea.setCodigo(m.getCodigo());
        linea.setNombre(m.getNombre());
        linea.setAfSubClaseId(m.getAfSubClaseId());
        linea.setAfUbicacionId(m.getAfUbicacionId());
        linea.setCentroCostoId(cc);
        linea.setFechaAdquisicion(m.getFechaAdquisicion());
        linea.setFechaInicioDepreciacion(fechaInicioDep);
        linea.setValorAdquisicion(m.getValorAdquisicion());
        linea.setDepreciacionAcumulada(depAcum);
        linea.setValorNeto(valorNeto);
        linea.setFlagEstado(m.getFlagEstado());
        linea.setEstadoActivo("1".equals(m.getFlagEstado()) ? "ACTIVO" : "INACTIVO");
        linea.setMoneda(monedaDefecto);
        linea.setClaseSubclase(resolverClaseSubclase(m.getAfSubClaseId()));
        linea.setUbicacionFisica(resolverUbicacion(m.getAfUbicacionId()));
        return linea;
    }

    private String resolverClaseSubclase(Long afSubClaseId) {
        return catalogoResolver.subClase(afSubClaseId)
                .map(sc -> {
                    String claseParte = catalogoResolver.clase(sc.getAfClaseId())
                            .map(c -> c.getCodigo() + " — " + c.getNombre())
                            .orElse("");
                    String subParte = sc.getCodigo() + " — " + sc.getNombre();
                    if (claseParte.isBlank()) {
                        return subParte;
                    }
                    return claseParte + " / " + subParte;
                })
                .orElse("");
    }

    private String resolverUbicacion(Long afUbicacionId) {
        return catalogoResolver.ubicacion(afUbicacionId)
                .map(u -> u.getCodigo() + " — " + u.getNombre())
                .orElse("");
    }

    private boolean pasaFiltro(AfMaestro m, Long afSubClaseId, Long afUbicacionId, String flagEstado,
                               String estadoActivo, BigDecimal valorMin, BigDecimal valorMax, Long afClaseId) {
        if (afSubClaseId != null && !afSubClaseId.equals(m.getAfSubClaseId())) {
            return false;
        }
        if (afUbicacionId != null && !afUbicacionId.equals(m.getAfUbicacionId())) {
            return false;
        }
        if (flagEstado != null && !flagEstado.equals(m.getFlagEstado())) {
            return false;
        }
        String estadoDerivado = "1".equals(m.getFlagEstado()) ? "ACTIVO" : "INACTIVO";
        if (estadoActivo != null && !estadoActivo.equals(estadoDerivado)) {
            return false;
        }
        if (valorMin != null && m.getValorAdquisicion().compareTo(valorMin) < 0) {
            return false;
        }
        if (valorMax != null && m.getValorAdquisicion().compareTo(valorMax) > 0) {
            return false;
        }
        if (afClaseId != null) {
            return subClaseRepository.findById(m.getAfSubClaseId())
                    .map(s -> afClaseId.equals(s.getAfClaseId()))
                    .orElse(false);
        }
        return true;
    }
}
