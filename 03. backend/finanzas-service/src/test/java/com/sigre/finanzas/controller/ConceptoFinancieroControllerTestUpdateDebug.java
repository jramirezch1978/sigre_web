package com.sigre.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import com.sigre.finanzas.dto.request.ConceptoFinancieroRequest;
import com.sigre.finanzas.entity.ConceptoFinanciero;
import com.sigre.finanzas.mapper.ConceptoFinancieroMapper;
import com.sigre.finanzas.service.ConceptoFinancieroService;

import java.time.Instant;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class ConceptoFinancieroControllerTestUpdateDebug {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ConceptoFinancieroService conceptoFinancieroService;

    @Autowired
    private ConceptoFinancieroMapper conceptoFinancieroMapper;


    // ==== testUpdateDebug — otros ====

    @Test
    void testUpdateDebug() throws Exception {
        // Arrange
        ConceptoFinancieroRequest request = new ConceptoFinancieroRequest();
        request.setCodigo("CF002");
        request.setNombre("TEST UPDATE");

        ConceptoFinanciero existingEntity = new ConceptoFinanciero();
        existingEntity.setId(1L);
        existingEntity.setCodigo("CF001");
        existingEntity.setNombre("VENTAS CONTADO");
        existingEntity.setFlagEstado("1");
        existingEntity.setCreatedBy(1L);
        existingEntity.setUpdatedBy(1L);
        existingEntity.setFecCreacion(Instant.now());
        existingEntity.setFecModificacion(Instant.now());

        ConceptoFinanciero updatedEntity = new ConceptoFinanciero();
        updatedEntity.setId(1L);
        updatedEntity.setCodigo("CF002");
        updatedEntity.setNombre("TEST UPDATE");
        updatedEntity.setFlagEstado("1");
        updatedEntity.setCreatedBy(1L);
        updatedEntity.setUpdatedBy(1L);
        updatedEntity.setFecCreacion(Instant.now());
        updatedEntity.setFecModificacion(Instant.now());

        when(conceptoFinancieroService.findById(1L)).thenReturn(existingEntity);
        when(conceptoFinancieroService.update(eq(1L), any(ConceptoFinanciero.class))).thenReturn(updatedEntity);

        // Act & Then
        mockMvc.perform(put("/api/finanzas/conceptos-financieros/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(new ObjectMapper().writeValueAsString(request))
                .header("X-Empresa-Id", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("CF002"));
    }
}
