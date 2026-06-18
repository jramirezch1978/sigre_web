package com.sigre.core.service;

import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.NumeradorDocumentoResponse;
import com.sigre.core.dto.PageData;

public interface NumeradorDocumentoService {

    PageData<NumeradorDocumentoResponse> listar(String nombreTabla, Pageable pageable);
}
