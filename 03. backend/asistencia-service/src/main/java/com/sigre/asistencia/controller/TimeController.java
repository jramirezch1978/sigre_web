package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.ServerTimeResponse;
import com.sigre.asistencia.service.TimeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/time")
@RequiredArgsConstructor
public class TimeController {

    private final TimeService timeService;

    @GetMapping("/current")
    public ResponseEntity<ServerTimeResponse> getCurrentTime() {
        ServerTimeResponse response = timeService.getCurrentServerTime();
        return ResponseEntity.ok(response);
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Asistencia Service is running - " + 
            timeService.getCurrentServerTime().getFormattedTime());
    }
}
