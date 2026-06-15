package com.sigre.contabilidad.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.contabilidad.dto.request.DocumentoDetalleRequest;
import com.sigre.contabilidad.dto.request.GenerarAsientoRequest;
import com.sigre.contabilidad.dto.request.ImportarPreasientoRequest;
import com.sigre.contabilidad.dto.response.GenerarPreasientoResponse;
import com.sigre.contabilidad.dto.response.ImportarPreasientoResponse;
import com.sigre.contabilidad.dto.response.ImportarPreasientoResponse.AsientoImportado;
import com.sigre.contabilidad.entity.*;
import com.sigre.contabilidad.enums.TipoOperacionContable;
import com.sigre.contabilidad.repository.*;
import com.sigre.contabilidad.service.ContabilidadErrorCodes;
import com.sigre.contabilidad.service.GenerarPreasientoService;
import com.sigre.contabilidad.support.AsientoPeriodoLibroValidator;
import com.sigre.contabilidad.support.AsientoPeriodoLibroValidator.PeriodoLibro;
import com.sigre.contabilidad.support.SucursalVoucherValidator;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class GenerarPreasientoServiceImpl implements GenerarPreasientoService {

    private static final String FLAG_DEBE = "D";

    private final CntblPreasientoRepository preasientoRepository;
    private final CntblPreasientoDetRepository preasientoDetRepository;
    private final CntblAsientoRepository asientoRepository;
    private final CntblAsientoDetRepository asientoDetRepository;
    private final MatrizContableRepository matrizContableRepository;
    private final ConceptoFinancieroRepository conceptoFinancieroRepository;
    private final AsientoPeriodoLibroValidator periodoLibroValidator;
    private final SucursalVoucherValidator sucursalVoucherValidator;

    @Override
    @Transactional
    @Timed(value = "app.contabilidad.generar_preasiento", extraTags = {"operation", "generar_pre"})
    public GenerarPreasientoResponse generarPreasiento(TipoOperacionContable tipoOperacion,
                                                        GenerarAsientoRequest request) {
        log.info("Generando pre-asiento - operacion: {}", tipoOperacion.name());

        PeriodoLibro periodoLibro = periodoLibroValidator.validar(
                request.getAno(), request.getMes(), request.getCntblLibroId());

        CntblPreasiento preasiento = buildPreasientoCabecera(tipoOperacion, request, periodoLibro);
        CntblPreasiento saved = preasientoRepository.save(preasiento);

        int lineas = generarLineasDetalle(saved, request);

        validarBalanceo(saved);

        log.info("Pre-asiento generado id={}, voucher={}, lineas={}",
                saved.getId(), saved.getVoucher(), lineas);

        GenerarPreasientoResponse response = new GenerarPreasientoResponse();
        response.setPreasientoId(saved.getId());
        response.setVoucher(saved.getVoucher());
        response.setModuloOrigen(tipoOperacion.getModulo());
        response.setTipoOperacion(tipoOperacion.name());
        response.setDocumentoOrigenId(request.getDocumentoId());
        response.setTotalLineasDetalle(lineas);
        response.setEstado(saved.getFlagEstado());
        return response;
    }

    @Override
    @Transactional
    @Timed(value = "app.contabilidad.importar_preasientos", extraTags = {"operation", "importar"})
    public ImportarPreasientoResponse importarPreasientos(ImportarPreasientoRequest request) {
        log.info("Importando pre-asientos - sucursal: {}, periodo: {}/{}",
                request.getSucursalId(), request.getAnio(), request.getMes());

        List<CntblPreasiento> pendientes = preasientoRepository
                .findPendientesBySucursalAndPeriodo(
                        request.getSucursalId(), request.getAnio(), request.getMes());

        if (pendientes.isEmpty()) {
            throw new BusinessException(
                    String.format("No hay pre-asientos pendientes para sucursal %d, periodo %d/%d",
                            request.getSucursalId(), request.getAnio(), request.getMes()),
                    HttpStatus.NOT_FOUND,
                    ContabilidadErrorCodes.PREASIENTO_SIN_PENDIENTES);
        }

        List<AsientoImportado> asientosImportados = new ArrayList<>();

        for (CntblPreasiento pre : pendientes) {
            AsientoImportado importado = copiarAAsiento(pre, request);
            asientosImportados.add(importado);
        }

        ImportarPreasientoResponse response = new ImportarPreasientoResponse();
        response.setTotalPreasientosImportados(asientosImportados.size());
        response.setTotalAsientosGenerados(asientosImportados.size());
        response.setAsientos(asientosImportados);

        log.info("Importación completada: {} pre-asientos -> {} asientos",
                asientosImportados.size(), asientosImportados.size());
        return response;
    }

    private AsientoImportado copiarAAsiento(CntblPreasiento pre, ImportarPreasientoRequest request) {
        Long sucursalId = sucursalVoucherValidator.validar(request.getSucursalId());
        String voucherAsiento = asientoRepository.getVoucherNumber(
                sucursalId,
                request.getAnio(),
                request.getMes(),
                request.getLibroId());

        CntblAsiento asiento = new CntblAsiento();
        asiento.setVoucher(voucherAsiento);
        asiento.setLibroId(request.getLibroId());
        asiento.setFecha(pre.getFecha());
        asiento.setGlosa(pre.getGlosa());
        asiento.setNaturalezaAsiento(pre.getNaturalezaAsiento());
        asiento.setModuloOrigen(pre.getModuloOrigen());
        asiento.setCntblPreasientoId(pre.getId());
        asiento.setMonedaId(pre.getMonedaId());
        asiento.setTasaCambio(pre.getTasaCambio());
        asiento.setCreatedBy(TenantContext.getUsuarioId());

        CntblAsiento savedAsiento = asientoRepository.save(asiento);

        int lineas = 0;
        for (CntblPreasientoDet preDet : pre.getDetalles()) {
            CntblAsientoDet det = new CntblAsientoDet();
            det.setCntblAsiento(savedAsiento);
            det.setPlanContableDetId(preDet.getPlanContableDetId());
            det.setCentrosCostoId(preDet.getCentrosCostoId());
            det.setEntidadContribuyenteId(preDet.getEntidadContribuyenteId());
            det.setGlosaDetalle(preDet.getGlosa() != null ? preDet.getGlosa() : pre.getGlosa());
            det.setDocTipoId(preDet.getDocTipoId());
            det.setNroReferencia(preDet.getNroReferencia());
            det.setCntasPagarId(preDet.getCntasPagarId());
            det.setCntasCobrarId(preDet.getCntasCobrarId());
            det.setSolicitudGiroId(preDet.getSolicitudGiroId());
            det.setAfMaestroId(preDet.getAfMaestroId());
            det.setCajaBancosId(preDet.getCajaBancosId());
            det.setLiquidacionId(preDet.getLiquidacionId());
            det.setFlagDebeHaber(preDet.getFlagDebeHaber());
            det.setImporteSol(preDet.getImporteSol());
            det.setImporteDol(preDet.getImporteDol());
            det.setCreatedBy(TenantContext.getUsuarioId());
            det.setFecCreacion(Instant.now());
            asientoDetRepository.save(det);
            lineas++;
        }

        pre.setFechaProcesamiento(LocalDate.now());
        preasientoRepository.save(pre);

        AsientoImportado importado = new AsientoImportado();
        importado.setPreasientoId(pre.getId());
        importado.setPreasientoVoucher(pre.getVoucher());
        importado.setAsientoId(savedAsiento.getId());
        importado.setAsientoVoucher(savedAsiento.getVoucher());
        importado.setLineasDetalle(lineas);
        return importado;
    }

    private CntblPreasiento buildPreasientoCabecera(TipoOperacionContable tipoOperacion,
                                                     GenerarAsientoRequest request,
                                                     PeriodoLibro periodoLibro) {
        Long sucursalId = sucursalVoucherValidator.validar(request.getSucursalId());

        String voucher = preasientoRepository.getVoucherNumber(
                sucursalId,
                periodoLibro.ano(),
                periodoLibro.mes(),
                periodoLibro.cntblLibroId());

        CntblPreasiento preasiento = new CntblPreasiento();
        preasiento.setVoucher(voucher);
        preasiento.setLibroId(periodoLibro.cntblLibroId());
        preasiento.setSucursalId(sucursalId);
        preasiento.setModuloOrigen(tipoOperacion.getModulo());
        preasiento.setNaturalezaAsiento(tipoOperacion.getTipoOperacion());
        preasiento.setFecha(request.getFecha());
        preasiento.setGlosa(buildGlosa(tipoOperacion, request));
        preasiento.setMonedaId(request.getMonedaId());
        preasiento.setTasaCambio(request.getTipoCambio());
        preasiento.setCreatedBy(TenantContext.getUsuarioId());
        return preasiento;
    }

    private int generarLineasDetalle(CntblPreasiento preasiento, GenerarAsientoRequest request) {
        Map<Long, MatrizContable> cache = new HashMap<>();
        int secuencia = 0;

        for (DocumentoDetalleRequest docDet : request.getDetalles()) {
            BigDecimal montoBase = docDet.getMonto() != null ? docDet.getMonto() : BigDecimal.ZERO;
            if (montoBase.compareTo(BigDecimal.ZERO) == 0) {
                continue;
            }

            MatrizContable matriz = resolverMatrizPorConcepto(docDet.getConceptoFinancieroId(), cache);

            for (MatrizContableDet lineaMatriz : matriz.getDetalles()) {
                BigDecimal importeSol = montoBase;
                BigDecimal importeDol = BigDecimal.ZERO;
                if (request.getTipoCambio() != null && request.getTipoCambio().compareTo(BigDecimal.ZERO) > 0) {
                    importeDol = montoBase.divide(request.getTipoCambio(), 4, RoundingMode.HALF_UP);
                }

                secuencia++;
                CntblPreasientoDet det = new CntblPreasientoDet();
                det.setCntblPreasiento(preasiento);
                det.setSecuencia(secuencia);
                det.setPlanContableDetId(resolverCuenta(lineaMatriz));
                det.setCentrosCostoId(docDet.getCentrosCostoId());
                det.setEntidadContribuyenteId(resolverEntidad(request));
                det.setGlosa(docDet.getGlosa());
                det.setFlagDebeHaber(lineaMatriz.getFlagDebHab());
                det.setImporteSol(importeSol);
                det.setImporteDol(importeDol);
                det.setCreatedBy(TenantContext.getUsuarioId());
                det.setFecCreacion(Instant.now());
                preasientoDetRepository.save(det);
            }
        }
        return secuencia;
    }

    private MatrizContable resolverMatrizPorConcepto(Long conceptoFinancieroId,
                                                     Map<Long, MatrizContable> cache) {
        ConceptoFinanciero concepto = conceptoFinancieroRepository
                .findById(conceptoFinancieroId)
                .orElseThrow(() -> new BusinessException(
                        String.format("Concepto financiero con ID %d no encontrado", conceptoFinancieroId),
                        HttpStatus.UNPROCESSABLE_ENTITY,
                        ContabilidadErrorCodes.CONCEPTO_FINANCIERO_NO_ENCONTRADO));

        if (!"1".equals(concepto.getFlagEstado())) {
            throw new BusinessException(
                    String.format("Concepto financiero '%s' está inactivo", concepto.getCodigo()),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.CONCEPTO_FINANCIERO_INACTIVO);
        }

        Long matrizId = concepto.getMatrizContableId();
        return cache.computeIfAbsent(matrizId, id ->
                matrizContableRepository.findByIdWithDetalles(id)
                        .orElseThrow(() -> new BusinessException(
                                String.format("Matriz contable ID %d (concepto '%s') no encontrada o inactiva",
                                        id, concepto.getCodigo()),
                                HttpStatus.UNPROCESSABLE_ENTITY,
                                ContabilidadErrorCodes.MATRIZ_CONTABLE_NO_ENCONTRADA))
        );
    }

    private Long resolverCuenta(MatrizContableDet lineaMatriz) {
        if (lineaMatriz.getPlanContableDetId() != null) {
            return lineaMatriz.getPlanContableDetId();
        }
        throw new BusinessException(
                "Matriz contable incompleta: falta cuenta para secuencia " + lineaMatriz.getSecuencia(),
                HttpStatus.UNPROCESSABLE_ENTITY,
                ContabilidadErrorCodes.PLAN_CONTABLE_NO_ENCONTRADO);
    }

    private Long resolverEntidad(GenerarAsientoRequest request) {
        if (request.getProveedorId() != null) return request.getProveedorId();
        return request.getClienteId();
    }

    private String buildGlosa(TipoOperacionContable tipoOperacion, GenerarAsientoRequest request) {
        if (request.getGlosa() != null && !request.getGlosa().isBlank()) {
            return request.getGlosa();
        }
        return String.format("Pre-asiento automático - %s", tipoOperacion.name());
    }

    private void validarBalanceo(CntblPreasiento preasiento) {
        BigDecimal sumaDebe = preasiento.getDetalles().stream()
                .filter(d -> FLAG_DEBE.equals(d.getFlagDebeHaber()))
                .map(d -> d.getImporteSol() != null ? d.getImporteSol() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal sumaHaber = preasiento.getDetalles().stream()
                .filter(d -> !FLAG_DEBE.equals(d.getFlagDebeHaber()))
                .map(d -> d.getImporteSol() != null ? d.getImporteSol() : BigDecimal.ZERO)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (sumaDebe.compareTo(sumaHaber) != 0) {
            log.error("Pre-asiento NO balanceado - Debe: {}, Haber: {}", sumaDebe, sumaHaber);
            throw new BusinessException(
                    String.format("El pre-asiento no está balanceado. Debe: %s, Haber: %s",
                            sumaDebe, sumaHaber),
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    ContabilidadErrorCodes.ASIENTO_NO_BALANCEADO);
        }
    }
}
