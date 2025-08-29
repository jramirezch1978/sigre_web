package com.sigre.asistencia.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServerTimeResponse {
    private LocalDateTime timestamp;
    private String formattedTime;    // hh:mm:ss a
    private String formattedDate;    // EEEE, d MMMM yyyy
    private String fullDateTime;     // yyyy-MM-dd HH:mm:ss
    private int hour;
    private int minute;
    private int second;
}
