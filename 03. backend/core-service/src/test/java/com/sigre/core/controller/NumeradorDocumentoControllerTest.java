package com.sigre.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.NumeradorDocumentoResponse;
import com.sigre.core.dto.PageData;
import com.sigre.core.dto.PageMeta;
import com.sigre.core.service.NumeradorDocumentoService;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class NumeradorDocumentoControllerTest {

    @Mock private NumeradorDocumentoService service;
    @InjectMocks private NumeradorDocumentoController controller;

    @Test
    void listarFiltraPorNombreTabla() {
        var page = PageData.<NumeradorDocumentoResponse>builder()
                .content(List.of(new NumeradorDocumentoResponse(
                        "ALMACEN.VALE_MOV", 1L, "01", "LIMA", 2026, 42L, "1")))
                .page(PageMeta.builder().number(0).size(20).totalElements(1).totalPages(1).build())
                .build();
        when(service.listar(eq("almacen.vale_mov"), any(Pageable.class))).thenReturn(page);

        var result = controller.listar("almacen.vale_mov", Pageable.ofSize(20));
        assertTrue(result.isSuccess());
        assertEquals(1, result.getData().getContent().size());
        verify(service).listar(eq("almacen.vale_mov"), any(Pageable.class));
    }
}
