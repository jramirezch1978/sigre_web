package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoResponse;
import com.sigre.rrhh.entity.*;
import com.sigre.rrhh.mapper.CalculoMapper;
import com.sigre.rrhh.repository.*;
import com.sigre.rrhh.service.CalculoService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class CalculoServiceImpl implements CalculoService {

    private final CalculoRepository calculoRepo;
    private final CalculoDetRepository calculoDetRepo;
    private final TrabajadorRepository trabajadorRepo;
    private final ContratoRepository contratoRepo;
    private final ConceptoPlanillaRepository conceptoRepo;
    private final AdminAfpRepository adminAfpRepo;
    private final CalculoMapper mapper;

    private static final String CONCEPTO_REMUNERACION_CODIGO = "C001";
    private static final String CONCEPTO_AFP_CODIGO = "D001";
    private static final String TIPO_CONCEPTO_INGRESO = "INGRESO";
    private static final String TIPO_CONCEPTO_DESCUENTO = "DESCUENTO";

    @Override
    @Transactional(readOnly = true)
    public Page<CalculoResponse> listar(Integer anio, Integer mes, Long tipoPlanillaId, Pageable pageable) {
        return calculoRepo.findWithFilters(anio, mes, tipoPlanillaId, pageable)
                .map(c -> mapper.toResponse(c, 0));
    }

    @Override
    @Transactional(readOnly = true)
    public CalculoDetalleResponse obtenerDetalle(Long id) {
        Calculo calculo = buscarOrThrow(id);
        List<CalculoDet> detalles = calculoDetRepo.findByCalculoIdOrderByTrabajadorId(id);
        return mapper.toDetalleResponse(calculo, detalles);
    }

    @Override
    @Timed("rrhh.calculo.procesar")
    public CalculoDetalleResponse procesar(Integer anio, Integer mes, Long tipoPlanillaId) {
        log.info("Iniciando cálculo de planilla: anio={}, mes={}, tipoPlanillaId={}", anio, mes, tipoPlanillaId);

        validarTipoPlanilla(tipoPlanillaId);

        calculoRepo.findByAnioAndMesAndTipoPlanillaId(anio, mes, tipoPlanillaId).ifPresent(existing -> {
            calculoDetRepo.deleteByCalculoId(existing.getId());
            calculoRepo.delete(existing);
        });

        List<Trabajador> activos = trabajadorRepo.findAll().stream()
                .filter(t -> "1".equals(t.getFlagEstado()))
                .toList();

        if (activos.isEmpty()) {
            throw new BusinessException(
                    "No existen trabajadores activos para procesar la planilla",
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-CA-004");
        }

        Long tipoConceptoIngresoId = resolveTipoConceptoCalculoId(TIPO_CONCEPTO_INGRESO);
        Long tipoConceptoDescuentoId = resolveTipoConceptoCalculoId(TIPO_CONCEPTO_DESCUENTO);

        ConceptoPlanilla conceptoIngreso = resolveConcepto(CONCEPTO_REMUNERACION_CODIGO, "INGRESO");
        ConceptoPlanilla conceptoAfp = resolveConcepto(CONCEPTO_AFP_CODIGO, "DESCUENTO");

        Calculo calculo = Calculo.builder()
                .anio(anio)
                .mes(mes)
                .tipoPlanillaId(tipoPlanillaId)
                .totalIngresos(BigDecimal.ZERO)
                .totalDescuentos(BigDecimal.ZERO)
                .totalNeto(BigDecimal.ZERO)
                .totalAportes(BigDecimal.ZERO)
                .build();

        calculo = calculoRepo.save(calculo);

        BigDecimal totalIngresos = BigDecimal.ZERO;
        BigDecimal totalDescuentos = BigDecimal.ZERO;
        BigDecimal totalAportes = BigDecimal.ZERO;
        List<CalculoDet> detalles = new ArrayList<>();

        for (Trabajador trabajador : activos) {
            Contrato contrato = findContratoActivo(trabajador.getId());
            if (contrato == null) continue;

            BigDecimal remuneracion = contrato.getRemuneracion() != null
                    ? contrato.getRemuneracion()
                    : BigDecimal.ZERO;

            CalculoDet detIngreso = CalculoDet.builder()
                    .calculoId(calculo.getId())
                    .trabajadorId(trabajador.getId())
                    .conceptoId(conceptoIngreso.getId())
                    .monto(remuneracion)
                    .tipoConceptoCalculoId(tipoConceptoIngresoId)
                    .build();
            detalles.add(detIngreso);
            totalIngresos = totalIngresos.add(remuneracion);

            if (trabajador.getAdminAfpId() != null) {
                BigDecimal descuentoAfp = calcularDescuentoAfp(trabajador.getAdminAfpId(), remuneracion);
                if (descuentoAfp.compareTo(BigDecimal.ZERO) > 0) {
                    CalculoDet detDescuento = CalculoDet.builder()
                            .calculoId(calculo.getId())
                            .trabajadorId(trabajador.getId())
                            .conceptoId(conceptoAfp.getId())
                            .monto(descuentoAfp)
                            .tipoConceptoCalculoId(tipoConceptoDescuentoId)
                            .build();
                    detalles.add(detDescuento);
                    totalDescuentos = totalDescuentos.add(descuentoAfp);
                    totalAportes = totalAportes.add(descuentoAfp);
                }
            }
        }

        calculoDetRepo.saveAll(detalles);

        BigDecimal totalNeto = totalIngresos.subtract(totalDescuentos);
        calculo.setTotalIngresos(totalIngresos);
        calculo.setTotalDescuentos(totalDescuentos);
        calculo.setTotalNeto(totalNeto);
        calculo.setTotalAportes(totalAportes);
        calculo = calculoRepo.save(calculo);

        log.info("Cálculo completado: ID={}, neto={}", calculo.getId(), totalNeto);
        return mapper.toDetalleResponse(calculo, detalles);
    }

    @Override
    @Timed("rrhh.calculo.eliminar")
    public void eliminar(Long id) {
        Calculo calculo = buscarOrThrow(id);
        calculoDetRepo.deleteByCalculoId(id);
        calculoRepo.delete(calculo);
    }

    private Calculo buscarOrThrow(Long id) {
        return calculoRepo.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Calculo", id));
    }

    private void validarTipoPlanilla(Long tipoPlanillaId) {
        if (tipoPlanillaId == null || !calculoRepo.existsTipoPlanillaById(tipoPlanillaId)) {
            throw new BusinessException(
                    "Tipo de planilla no encontrado con ID: " + tipoPlanillaId,
                    HttpStatus.BAD_REQUEST, "RH-CA-001");
        }
    }

    private Long resolveTipoConceptoCalculoId(String codigo) {
        Long id = calculoRepo.findTipoConceptoCalculoIdByCodigo(codigo);
        if (id == null) {
            throw new BusinessException(
                    "Tipo de concepto de cálculo no configurado para el código: " + codigo,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-CA-005");
        }
        return id;
    }

    private Contrato findContratoActivo(Long trabajadorId) {
        List<Contrato> contratos = contratoRepo.findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(trabajadorId, "1");
        return contratos.isEmpty() ? null : contratos.get(0);
    }

    private ConceptoPlanilla resolveConcepto(String codigo, String tipo) {
        return conceptoRepo.findAll().stream()
                .filter(cp -> codigo.equals(cp.getCodigo()))
                .findFirst()
                .orElseGet(() -> {
                    String nombre = "INGRESO".equals(tipo) ? "Remuneración básica" : "Aporte AFP";
                    ConceptoPlanilla nuevo = new ConceptoPlanilla();
                    nuevo.setCodigo(codigo);
                    nuevo.setNombre(nombre);
                    nuevo.setTipo(tipo);
                    return conceptoRepo.save(nuevo);
                });
    }

    private BigDecimal calcularDescuentoAfp(Long adminAfpId, BigDecimal remuneracion) {
        return adminAfpRepo.findById(adminAfpId)
                .map(afp -> {
                    BigDecimal comision = afp.getComisionPorcentaje() != null ? afp.getComisionPorcentaje() : BigDecimal.ZERO;
                    BigDecimal prima = afp.getPrimaSeguro() != null ? afp.getPrimaSeguro() : BigDecimal.ZERO;
                    BigDecimal aporte = afp.getAporteObligatorio() != null ? afp.getAporteObligatorio() : BigDecimal.ZERO;
                    BigDecimal totalPorcentaje = comision.add(prima).add(aporte);
                    return remuneracion.multiply(totalPorcentaje)
                            .divide(BigDecimal.valueOf(100), 4, RoundingMode.HALF_UP);
                })
                .orElse(BigDecimal.ZERO);
    }
}
