package com.sigre.seguridad.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sigre.seguridad.dto.seguridad.EdicionErpDto;
import com.sigre.seguridad.dto.seguridad.LandingCatalogoDto;
import com.sigre.seguridad.dto.seguridad.ModuloDto;
import com.sigre.seguridad.dto.seguridad.PlanSuscripcionDto;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class LandingCatalogService {

    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper;

    public LandingCatalogoDto obtenerCatalogo() {
        return LandingCatalogoDto.builder()
                .ediciones(listarEdiciones())
                .planes(listarPlanes())
                .build();
    }

    public List<EdicionErpDto> listarEdiciones() {
        List<EdicionErpDto> ediciones = jdbcTemplate.query(
                """
                SELECT id, codigo, nombre, descripcion, orden, flag_estado
                FROM auth.edicion_erp
                WHERE flag_estado = '1'
                ORDER BY orden, nombre
                """,
                (rs, i) -> EdicionErpDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .descripcion(rs.getString("descripcion"))
                        .orden(rs.getInt("orden"))
                        .activo("1".equals(rs.getString("flag_estado")))
                        .modulos(new ArrayList<>())
                        .build());

        if (ediciones.isEmpty()) {
            return ediciones;
        }

        Map<Long, EdicionErpDto> porId = new LinkedHashMap<>();
        for (EdicionErpDto edicion : ediciones) {
            porId.put(edicion.getId(), edicion);
        }

        jdbcTemplate.query(
                """
                SELECT em.edicion_id, m.id, m.codigo, m.nombre, m.flag_estado
                FROM auth.edicion_modulo em
                JOIN auth.modulo m ON m.id = em.modulo_id
                WHERE m.flag_estado = '1'
                ORDER BY em.edicion_id, m.nombre
                """,
                rs -> {
                    EdicionErpDto edicion = porId.get(rs.getLong("edicion_id"));
                    if (edicion == null) {
                        return;
                    }
                    edicion.getModulos().add(
                            ModuloDto.builder()
                                    .id(rs.getLong("id"))
                                    .codigo(rs.getString("codigo"))
                                    .nombre(rs.getString("nombre"))
                                    .activo("1".equals(rs.getString("flag_estado")))
                                    .build());
                });

        return ediciones;
    }

    public List<PlanSuscripcionDto> listarPlanes() {
        return jdbcTemplate.query(
                """
                SELECT id, codigo, nombre, precio, descripcion, edicion_codigo, color, destacado,
                       dias_demo, max_usuarios, orden, caracteristicas, flag_estado
                FROM auth.plan_suscripcion
                WHERE flag_estado = '1'
                ORDER BY orden, nombre
                """,
                (rs, i) -> PlanSuscripcionDto.builder()
                        .id(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .nombre(rs.getString("nombre"))
                        .precio(rs.getBigDecimal("precio") != null ? rs.getBigDecimal("precio") : BigDecimal.ZERO)
                        .descripcion(rs.getString("descripcion"))
                        .edicionCodigo(rs.getString("edicion_codigo"))
                        .color(rs.getString("color"))
                        .destacado(rs.getBoolean("destacado"))
                        .diasDemo((Integer) rs.getObject("dias_demo"))
                        .maxUsuarios((Integer) rs.getObject("max_usuarios"))
                        .orden(rs.getInt("orden"))
                        .caracteristicas(parseCaracteristicas(rs.getString("caracteristicas")))
                        .activo("1".equals(rs.getString("flag_estado")))
                        .build());
    }

    private List<String> parseCaracteristicas(String json) {
        if (json == null || json.isBlank()) {
            return List.of();
        }
        try {
            return objectMapper.readValue(json, new TypeReference<List<String>>() {});
        } catch (Exception ex) {
            return List.of();
        }
    }
}
