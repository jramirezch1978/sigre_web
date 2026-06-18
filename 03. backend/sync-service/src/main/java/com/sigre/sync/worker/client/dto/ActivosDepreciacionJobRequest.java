package com.sigre.sync.worker.client.dto;

import lombok.Data;

@Data
public class ActivosDepreciacionJobRequest {
    private Integer anio;
    private Integer mes;
}
