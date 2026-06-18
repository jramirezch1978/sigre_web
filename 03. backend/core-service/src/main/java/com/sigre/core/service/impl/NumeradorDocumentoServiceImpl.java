package com.sigre.core.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.core.dto.NumeradorDocumentoResponse;
import com.sigre.core.dto.PageData;
import com.sigre.core.dto.PageMeta;
import com.sigre.core.service.NumeradorDocumentoService;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NumeradorDocumentoServiceImpl implements NumeradorDocumentoService {

    private final JdbcTemplate jdbcTemplate;

    @Override
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

    private static String normalizarNombreTabla(String nombreTabla) {
        if (nombreTabla == null || nombreTabla.isBlank()) {
            return null;
        }
        return nombreTabla.trim().toUpperCase();
    }
}
