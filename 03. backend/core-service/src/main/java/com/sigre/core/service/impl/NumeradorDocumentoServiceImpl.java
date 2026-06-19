package com.sigre.core.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.core.dto.NumeradorDocumentoResponse;
import com.sigre.core.dto.NumeradorDocumentoUpsertRequest;
import com.sigre.core.dto.PageData;
import com.sigre.core.dto.PageMeta;
import com.sigre.core.service.NumeradorDocumentoService;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NumeradorDocumentoServiceImpl implements NumeradorDocumentoService {

    private final JdbcTemplate jdbcTemplate;

    @Override
    @Transactional(readOnly = true)
    public PageData<NumeradorDocumentoResponse> listar(String nombreTabla, Pageable pageable) {
        String filtroTabla = normalizarNombreTabla(nombreTabla);
        List<Object> params = new ArrayList<>();
        StringBuilder where = new StringBuilder(" WHERE nd.flag_estado = '1' ");
        if (filtroTabla != null) {
            where.append(" AND UPPER(nd.nombre_tabla) = ? ");
            params.add(filtroTabla);
        }

        Long total = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM core.numerador_documento nd" + where,
                Long.class,
                params.toArray());

        int limit = pageable.isPaged() ? pageable.getPageSize() : 500;
        int offset = pageable.isPaged() ? (int) pageable.getOffset() : 0;

        List<Object> queryParams = new ArrayList<>(params);
        queryParams.add(limit);
        queryParams.add(offset);

        List<NumeradorDocumentoResponse> content = jdbcTemplate.query(
                """
                SELECT nd.nombre_tabla,
                       nd.sucursalid AS sucursal_id,
                       nd.ano,
                       nd.ult_nro,
                       nd.flag_estado,
                       s.codigo AS sucursal_codigo,
                       s.nombre AS sucursal_nombre
                FROM core.numerador_documento nd
                LEFT JOIN auth.sucursal s ON s.id = nd.sucursalid
                """ + where + """
                ORDER BY nd.nombre_tabla, nd.sucursalid, nd.ano DESC
                LIMIT ? OFFSET ?
                """,
                (rs, rowNum) -> new NumeradorDocumentoResponse(
                        rs.getString("nombre_tabla"),
                        rs.getLong("sucursal_id"),
                        rs.getString("sucursal_codigo"),
                        rs.getString("sucursal_nombre"),
                        rs.getInt("ano"),
                        rs.getLong("ult_nro"),
                        rs.getString("flag_estado")
                ),
                queryParams.toArray());

        long totalElements = total != null ? total : 0L;
        int totalPages = limit > 0 ? (int) Math.ceil((double) totalElements / limit) : 1;
        int pageNumber = pageable.isPaged() ? pageable.getPageNumber() : 0;

        return PageData.<NumeradorDocumentoResponse>builder()
                .content(content)
                .page(PageMeta.builder()
                        .number(pageNumber)
                        .size(limit)
                        .totalElements(totalElements)
                        .totalPages(totalPages)
                        .build())
                .build();
    }

    @Override
    @Transactional
    public NumeradorDocumentoResponse upsert(NumeradorDocumentoUpsertRequest request) {
        String nombreTabla = normalizarNombreTabla(request.getNombreTabla());
        int updated = jdbcTemplate.update(
                """
                UPDATE core.numerador_documento
                SET ult_nro = ?, flag_estado = ?, fec_modificacion = NOW()
                WHERE UPPER(nombre_tabla) = ? AND sucursalid = ? AND ano = ?
                """,
                request.getUltNro(),
                request.getFlagEstado() != null ? request.getFlagEstado() : "1",
                nombreTabla,
                request.getSucursalId(),
                request.getAno());
        if (updated == 0) {
            jdbcTemplate.update(
                    """
                    INSERT INTO core.numerador_documento (nombre_tabla, sucursalid, ano, ult_nro, flag_estado, fec_creacion)
                    VALUES (?, ?, ?, ?, ?, NOW())
                    """,
                    nombreTabla,
                    request.getSucursalId(),
                    request.getAno(),
                    request.getUltNro(),
                    request.getFlagEstado() != null ? request.getFlagEstado() : "1");
        }
        return buscarUno(nombreTabla, request.getSucursalId(), request.getAno());
    }

    @Override
    @Transactional
    public void desactivar(String nombreTabla, Long sucursalId, Integer ano) {
        jdbcTemplate.update(
                """
                UPDATE core.numerador_documento
                SET flag_estado = '0', fec_modificacion = NOW()
                WHERE UPPER(nombre_tabla) = ? AND sucursalid = ? AND ano = ?
                """,
                normalizarNombreTabla(nombreTabla),
                sucursalId,
                ano);
    }

    private NumeradorDocumentoResponse buscarUno(String nombreTabla, Long sucursalId, Integer ano) {
        List<NumeradorDocumentoResponse> rows = jdbcTemplate.query(
                """
                SELECT nd.nombre_tabla,
                       nd.sucursalid AS sucursal_id,
                       nd.ano,
                       nd.ult_nro,
                       nd.flag_estado,
                       s.codigo AS sucursal_codigo,
                       s.nombre AS sucursal_nombre
                FROM core.numerador_documento nd
                LEFT JOIN auth.sucursal s ON s.id = nd.sucursalid
                WHERE UPPER(nd.nombre_tabla) = ? AND nd.sucursalid = ? AND nd.ano = ?
                """,
                (rs, rowNum) -> new NumeradorDocumentoResponse(
                        rs.getString("nombre_tabla"),
                        rs.getLong("sucursal_id"),
                        rs.getString("sucursal_codigo"),
                        rs.getString("sucursal_nombre"),
                        rs.getInt("ano"),
                        rs.getLong("ult_nro"),
                        rs.getString("flag_estado")
                ),
                nombreTabla,
                sucursalId,
                ano);
        if (rows.isEmpty()) {
            throw new IllegalStateException("Numerador no encontrado tras upsert");
        }
        return rows.get(0);
    }

    private static String normalizarNombreTabla(String nombreTabla) {
        if (nombreTabla == null || nombreTabla.isBlank()) {
            return null;
        }
        return nombreTabla.trim().toUpperCase();
    }
}
