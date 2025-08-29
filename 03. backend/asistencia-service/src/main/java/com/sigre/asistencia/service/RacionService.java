package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.RacionResponse;
import com.sigre.asistencia.dto.RacionSelectionRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RacionService {

    private final TimeService timeService;

    public List<RacionResponse> getRacionesDisponibles() {
        List<RacionResponse> raciones = new ArrayList<>();
        int currentHour = timeService.getCurrentLimaHour();

        // Desayuno: 6:00 - 9:00
        raciones.add(RacionResponse.builder()
                .id("desayuno")
                .nombre("Desayuno")
                .descripcion("Incluye café, pan, mantequilla, mermelada y fruta fresca")
                .icono("free_breakfast")
                .disponible(currentHour >= 6 && currentHour < 9)
                .color("#f59e0b")
                .horario("06:00 - 09:00")
                .build());

        // Almuerzo: disponible hasta mediodía
        raciones.add(RacionResponse.builder()
                .id("almuerzo")
                .nombre("Almuerzo")
                .descripcion("Plato principal con ensalada, sopa y postre")
                .icono("lunch_dining")
                .disponible(currentHour < 12)
                .color("#10b981")
                .horario("12:00 - 15:00")
                .build());

        // Cena: disponible después de mediodía
        raciones.add(RacionResponse.builder()
                .id("cena")
                .nombre("Cena")
                .descripcion("Cena ligera con ensalada y proteína")
                .icono("dinner_dining")
                .disponible(currentHour >= 12)
                .color("#1e3a8a")
                .horario("18:00 - 21:00")
                .build());

        return raciones;
    }

    public String seleccionarRacion(RacionSelectionRequest request) {
        // Validar disponibilidad
        List<RacionResponse> racionesDisponibles = getRacionesDisponibles();
        
        boolean racionDisponible = racionesDisponibles.stream()
                .anyMatch(r -> r.getId().equals(request.getRacionId()) && r.isDisponible());

        if (!racionDisponible) {
            return "Error: La ración seleccionada no está disponible en este horario";
        }

        // Simular registro de selección
        String nombreRacion = racionesDisponibles.stream()
                .filter(r -> r.getId().equals(request.getRacionId()))
                .findFirst()
                .map(RacionResponse::getNombre)
                .orElse("Desconocida");

        return String.format("Ración %s seleccionada exitosamente para la tarjeta %s a las %s", 
                nombreRacion, 
                request.getCodigoTarjeta(), 
                timeService.getCurrentServerTime().getFormattedTime());
    }

    public String getHorarioDisponible() {
        int hour = timeService.getCurrentLimaHour();
        
        if (hour < 12) {
            return "Hasta mediodía puede elegir Almuerzo y/o Cena";
        } else {
            return "Solo disponible Cena después del mediodía";
        }
    }
}
