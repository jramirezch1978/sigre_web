package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.ProgramVacacionCreateRequest;
import pe.restaurant.rrhh.dto.request.ProgramVacacionImportarRequest;
import pe.restaurant.rrhh.dto.request.ProgramVacacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.ProgramVacacionResponse;
import pe.restaurant.rrhh.entity.ProgramVacacion;
import pe.restaurant.rrhh.mapper.ProgramVacacionMapper;
import pe.restaurant.rrhh.repository.ProgramVacacionRepository;
import pe.restaurant.rrhh.service.ProgramVacacionService;
import java.io.ByteArrayOutputStream;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ProgramVacacionServiceImpl implements ProgramVacacionService {

    private final ProgramVacacionRepository repository;
    private final ProgramVacacionMapper mapper;

    @Override @Timed("rrhh.programVacacion.listar")
    public Page<ProgramVacacionResponse> listar(Long trabajadorId, Integer anio, Pageable pageable) {
        if (trabajadorId != null && anio != null) {
            var list = mapper.toResponseList(repository.findByTrabajadorIdAndAnio(trabajadorId, anio));
            return new PageImpl<>(list, pageable, list.size());
        }
        return repository.findAll(pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.programVacacion.obtener")
    public ProgramVacacionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.programVacacion.crear")
    public ProgramVacacionResponse crear(ProgramVacacionCreateRequest request) {
        var entity = mapper.toEntity(request);
        entity.setFlagEstado("1");
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.programVacacion.actualizar")
    public ProgramVacacionResponse actualizar(Long id, ProgramVacacionUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.programVacacion.desactivar")
    public ProgramVacacionResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.programVacacion.importar")
    public List<ProgramVacacionResponse> importar(ProgramVacacionImportarRequest request) {
        List<ProgramVacacionResponse> results = new ArrayList<>();
        for (ProgramVacacionImportarRequest.ProgramVacacionImportRow row : request.registros()) {
            ProgramVacacion p = new ProgramVacacion();
            p.setTrabajadorId(row.trabajadorId());
            p.setAnio(request.anio());
            p.setMes(row.mes());
            p.setDiasProgramados(row.diasProgramados());
            p.setObservacion(row.observacion());
            p.setFlagEstado("1");
            p.setCreatedBy(TenantContext.getUsuarioId());
            p.setFecCreacion(Instant.now());
            results.add(mapper.toResponse(repository.save(p)));
        }
        return results;
    }

    @Override @Timed("rrhh.programVacacion.exportar")
    public byte[] exportarExcel(Integer anio) {
        List<ProgramVacacion> list;
        if (anio != null) {
            list = repository.findByAnio(anio);
        } else {
            list = repository.findAll();
        }

        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("ProgramacionVacaciones");
            Row header = sheet.createRow(0);
            String[] cols = {"ID", "Trabajador ID", "Año", "Mes", "Días Programados", "Observación", "Estado"};
            for (int i = 0; i < cols.length; i++) {
                header.createCell(i).setCellValue(cols[i]);
            }
            int r = 1;
            for (ProgramVacacion p : list) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(p.getId() != null ? p.getId() : 0);
                row.createCell(1).setCellValue(p.getTrabajadorId() != null ? p.getTrabajadorId() : 0);
                row.createCell(2).setCellValue(p.getAnio() != null ? p.getAnio() : 0);
                row.createCell(3).setCellValue(p.getMes() != null ? p.getMes() : 0);
                row.createCell(4).setCellValue(p.getDiasProgramados() != null ? p.getDiasProgramados() : 0);
                row.createCell(5).setCellValue(p.getObservacion() != null ? p.getObservacion() : "");
                row.createCell(6).setCellValue(p.getFlagEstado() != null ? p.getFlagEstado() : "");
            }
            for (int i = 0; i < cols.length; i++) sheet.autoSizeColumn(i);
            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al exportar Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "RH-PV-500");
        }
    }

    private ProgramVacacion buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Programación vacacional no encontrada: {}", id);
            return new ResourceNotFoundException("ProgramVacacion", id);
        });
    }
}
