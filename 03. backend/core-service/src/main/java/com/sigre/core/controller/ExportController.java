package com.sigre.core.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sigre.core.dto.ExportRequest;
import com.sigre.core.service.ExportDocumentoService;

import lombok.RequiredArgsConstructor;

/**
 * Exportación genérica de consultas/reportes: el frontend envía cabeceras + filas formateadas
 * y el backend devuelve el documento (xlsx/docx/pdf) como descarga.
 */
@RestController
@RequestMapping("/api/core/export")
@RequiredArgsConstructor
public class ExportController {

    private final ExportDocumentoService service;

    @PostMapping
    public ResponseEntity<byte[]> exportar(
            @RequestParam String formato,
            @RequestBody ExportRequest req) {

        String fmt = formato == null ? "" : formato.trim().toLowerCase();
        byte[] bytes;
        String contentType;
        String ext;

        switch (fmt) {
            case "xlsx":
                bytes = service.excel(req.getTitulo(), req.getHeaders(), req.getFilas());
                contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                ext = "xlsx";
                break;
            case "docx":
                bytes = service.word(req.getTitulo(), req.getHeaders(), req.getFilas());
                contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                ext = "docx";
                break;
            case "pdf":
                bytes = service.pdf(req.getTitulo(), req.getHeaders(), req.getFilas());
                contentType = "application/pdf";
                ext = "pdf";
                break;
            default:
                return ResponseEntity.badRequest().build();
        }

        String filename = nombreArchivoSeguro(req.getTitulo()) + "." + ext;
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(contentType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .body(bytes);
    }

    private String nombreArchivoSeguro(String nombre) {
        if (nombre == null || nombre.isBlank()) {
            return "sigre-export";
        }
        String s = nombre.trim().toLowerCase()
                .replaceAll("\\s+", "-")
                .replaceAll("[^a-z0-9\\-_]", "");
        return s.isBlank() ? "sigre-export" : s;
    }
}
