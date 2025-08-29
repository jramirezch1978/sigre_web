package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.ServerTimeResponse;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class TimeService {

    private static final ZoneId LIMA_ZONE = ZoneId.of("America/Lima");
    private static final Locale SPANISH_LOCALE = new Locale("es", "PE");
    
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("hh:mm:ss a", SPANISH_LOCALE);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("EEEE, d MMMM yyyy", SPANISH_LOCALE);
    private static final DateTimeFormatter FULL_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public ServerTimeResponse getCurrentServerTime() {
        ZonedDateTime nowInLima = ZonedDateTime.now(LIMA_ZONE);
        LocalDateTime now = nowInLima.toLocalDateTime();
        
        return ServerTimeResponse.builder()
                .timestamp(now)
                .formattedTime(now.format(TIME_FORMATTER))
                .formattedDate(now.format(DATE_FORMATTER))
                .fullDateTime(now.format(FULL_FORMATTER))
                .hour(now.getHour())
                .minute(now.getMinute())
                .second(now.getSecond())
                .build();
    }

    public boolean isBeforeNoon() {
        return getCurrentLimaHour() < 12;
    }

    public boolean isAfterNoon() {
        return getCurrentLimaHour() >= 12;
    }

    public boolean isBreakfastTime() {
        int hour = getCurrentLimaHour();
        return hour >= 6 && hour < 9;
    }

    public boolean isLunchTime() {
        int hour = getCurrentLimaHour();
        return hour >= 12 && hour < 15;
    }

    public boolean isDinnerTime() {
        int hour = getCurrentLimaHour();
        return hour >= 18 && hour < 21;
    }
    
    public int getCurrentLimaHour() {
        return ZonedDateTime.now(LIMA_ZONE).getHour();
    }
}
