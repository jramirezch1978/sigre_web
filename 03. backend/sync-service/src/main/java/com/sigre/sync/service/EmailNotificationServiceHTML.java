package com.sigre.sync.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.jdbc.core.JdbcTemplate;

import jakarta.mail.internet.MimeMessage;
import javax.sql.DataSource;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
public class EmailNotificationServiceHTML {
    
    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    @Autowired
    private RemoteToLocalSyncService remoteToLocalSync;
    
    @Autowired
    private LocalToRemoteSyncService localToRemoteSync;
    
    // JdbcTemplate para consultas directas
    private final JdbcTemplate jdbcTemplateLocal;
    private final JdbcTemplate jdbcTemplateRemote;
    
    // Inyectar repositorios para contar registros actuales
    @Autowired
    private com.sigre.sync.repository.local.MaestroLocalRepository maestroLocalRepo;
    
    @Autowired
    private com.sigre.sync.repository.remote.MaestroRemoteRepository maestroRemoteRepo;
    
    @Autowired
    private com.sigre.sync.repository.local.CentrosCostoLocalRepository centrosLocalRepo;
    
    @Autowired
    private com.sigre.sync.repository.remote.CentrosCostoRemoteRepository centrosRemoteRepo;
    
    @Autowired
    private com.sigre.sync.repository.local.RrhhAsignaTrjtRelojLocalRepository tarjetasLocalRepo;
    
    @Autowired
    private com.sigre.sync.repository.remote.RrhhAsignaTrjtRelojRemoteRepository tarjetasRemoteRepo;
    
    @Autowired
    private com.sigre.sync.repository.local.AsistenciaHt580LocalRepository asistenciaLocalRepo;
    
    @Autowired
    private com.sigre.sync.repository.remote.AsistenciaHt580RemoteRepository asistenciaRemoteRepo;
    
    @Value("${spring.mail.notifications.recipients:jramirez@npssac.com.pe}")
    private List<String> recipients;
    
    @Value("${spring.mail.notifications.subject:[SIGRE] Reporte de Sincronización}")
    private String subject;
    
    @Value("${spring.mail.notifications.enabled:true}")
    private boolean emailEnabled;
    
    @Value("${spring.mail.smtp.from:facturacion.electronica@franevi.com}")
    private String fromEmail;
    
    // Parámetro configurable para días de estadísticas
    @Value("${sync.statistics.days:7}")
    private int diasEstadisticas;
    
    // Constructor para inyectar JdbcTemplates
    public EmailNotificationServiceHTML(
            @Qualifier("localDataSource") DataSource localDataSource,
            @Qualifier("remoteDataSource") DataSource remoteDataSource) {
        this.jdbcTemplateLocal = new JdbcTemplate(localDataSource);
        this.jdbcTemplateRemote = new JdbcTemplate(remoteDataSource);
    }
    
    /**
     * Enviar reporte de sincronización por email en formato HTML
     */
    public void enviarReporteSincronizacion(SyncReport report) {
        if (!emailEnabled || mailSender == null) {
            log.info("📧 Notificaciones por email deshabilitadas o no configuradas");
            return;
        }
        
        try {
            String contenidoHtml = construirContenidoEmailHTML(report);
            
            for (String recipient : recipients) {
                enviarEmailHTML(recipient, subject, contenidoHtml);
            }
            
            log.info("📧 Reporte de sincronización enviado a {} destinatarios", recipients.size());
            
        } catch (Exception e) {
            log.error("❌ Error al enviar reporte de sincronización por email", e);
        }
    }
    
    /**
     * Enviar email HTML individual
     */
    private void enviarEmailHTML(String to, String subject, String htmlContent) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);
            
            mailSender.send(message);
            log.debug("📧 Email HTML enviado exitosamente a: {}", to);
            
        } catch (Exception e) {
            log.error("❌ Error al enviar email a: {}", to, e);
        }
    }
    
    /**
     * Obtener los códigos de origen activos en la base local
     */
    private Set<String> obtenerCodigosOrigenLocal() {
        Set<String> codigos = new HashSet<>();
        try {
            String sql = "SELECT DISTINCT COD_ORIGEN FROM asistencia_ht580 WHERE COD_ORIGEN IS NOT NULL";
            List<String> result = jdbcTemplateLocal.queryForList(sql, String.class);
            codigos.addAll(result);
            log.info("📍 Códigos de origen encontrados en BD Local: {}", codigos);
        } catch (Exception e) {
            log.error("Error obteniendo códigos de origen", e);
        }
        return codigos;
    }
    
    /**
     * Construir contenido del email en formato HTML
     */
    private String construirContenidoEmailHTML(SyncReport report) {
        StringBuilder html = new StringBuilder();
        
        // Inicio del HTML con estilos CSS
        html.append("<!DOCTYPE html>");
        html.append("<html>");
        html.append("<head>");
        html.append("<meta charset='UTF-8'>");
        html.append("<style>");
        html.append("body { font-family: Arial, sans-serif; background-color: #f5f5f5; padding: 20px; }");
        html.append(".container { max-width: 1200px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }");
        html.append("h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }");
        html.append("h2 { color: #34495e; margin-top: 30px; border-bottom: 2px solid #ecf0f1; padding-bottom: 5px; }");
        html.append("h3 { color: #34495e; margin-top: 20px; }");
        html.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        html.append("th { background-color: #3498db; color: white; padding: 12px; text-align: left; }");
        html.append("td { padding: 10px; border-bottom: 1px solid #ecf0f1; }");
        html.append("tr:hover { background-color: #f8f9fa; }");
        html.append(".success { color: #27ae60; font-weight: bold; }");
        html.append(".error { color: #e74c3c; font-weight: bold; }");
        html.append(".warning { color: #f39c12; font-weight: bold; }");
        html.append(".info-box { background-color: #ecf0f1; padding: 15px; border-radius: 5px; margin: 15px 0; }");
        html.append(".footer { margin-top: 40px; padding-top: 20px; border-top: 2px solid #ecf0f1; text-align: center; color: #7f8c8d; }");
        html.append(".stats-equal { background-color: #d4edda; }");
        html.append(".stats-diff { background-color: #f8d7da; }");
        html.append(".origen-table { margin-top: 10px; }");
        html.append(".origen-table td { font-size: 14px; }");
        html.append("</style>");
        html.append("</head>");
        html.append("<body>");
        html.append("<div class='container'>");
        
        // Encabezado
        html.append("<h1>📊 REPORTE DE SINCRONIZACIÓN SIGRE</h1>");
        
        // Información general
        html.append("<div class='info-box'>");
        html.append("<p><strong>Fecha y Hora:</strong> ").append(report.getFechaHora().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("</p>");
        html.append("<p><strong>Duración Total:</strong> ").append(report.getDuracionMinutos()).append(" minutos</p>");
        html.append("<p><strong>Estado General:</strong> ");
        if (report.isExitoso()) {
            html.append("<span class='success'>✅ EXITOSO</span>");
        } else {
            html.append("<span class='error'>❌ CON ERRORES</span>");
        }
        html.append("</p>");
        html.append("<p><strong>Próxima Sincronización:</strong> ").append(report.getProximaSincronizacion().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))).append("</p>");
        html.append("</div>");
        
        // Tabla principal de sincronización
        html.append("<h2>📋 Resumen Detallado de Sincronización</h2>");
        html.append("<table>");
        html.append("<thead>");
        html.append("<tr>");
        html.append("<th>Tabla</th>");
        html.append("<th>Dirección</th>");
        html.append("<th>Insertados</th>");
        html.append("<th>Actualizados</th>");
        html.append("<th>Eliminados</th>");
        html.append("<th>Errores</th>");
        html.append("<th>Registros Local</th>");
        html.append("<th>Registros Remoto</th>");
        html.append("<th>Estado</th>");
        html.append("</tr>");
        html.append("</thead>");
        html.append("<tbody>");
        
        // Obtener conteos actuales de registros
        Map<String, Long[]> conteos = obtenerConteosActuales();
        
        for (Map.Entry<String, SyncTableStats> entry : report.getEstadisticasDetalladas().entrySet()) {
            SyncTableStats stats = entry.getValue();
            Long[] conteo = conteos.get(entry.getKey());
            
            // Manejo seguro para tablas sin conteo definido (como turno)
            long countLocal = 0;
            long countRemote = 0;
            
            if (conteo != null) {
                countLocal = conteo[0];
                countRemote = conteo[1];
            } else {
                log.debug("⚠️ No hay conteo definido para tabla: {} - usando valores por defecto", entry.getKey());
                // Para tablas de referencia como turno, usar conteo básico
                countLocal = stats.getRegistrosInsertados() + stats.getRegistrosActualizados();
                countRemote = countLocal; // Estimación
            }
            
            // Para asistencia_ht580, mostrar detalle por origen
            if (entry.getKey().equals("asistencia_ht580")) {
                Map<String, Long[]> conteoPorOrigen = obtenerConteoAsistenciaPorOrigen();
                
                html.append("<tr>");
                html.append("<td><strong>").append(stats.getNombreTabla()).append("</strong></td>");
                html.append("<td>").append(stats.getDireccion().equals("REMOTE_TO_LOCAL") ? "Oracle → PostgreSQL" : "PostgreSQL → Oracle").append("</td>");
                html.append("<td>").append(stats.getRegistrosInsertados()).append("</td>");
                html.append("<td>").append(stats.getRegistrosActualizados()).append("</td>");
                html.append("<td>").append(stats.getRegistrosEliminados()).append("</td>");
                html.append("<td>").append(stats.getRegistrosErrores() > 0 ? "<span class='error'>" + stats.getRegistrosErrores() + "</span>" : "0").append("</td>");
                html.append("<td>").append(countLocal).append("</td>");
                html.append("<td>").append(countRemote).append("</td>");
                html.append("<td>");
                if (stats.isExitoso()) {
                    html.append("<span class='success'>✅ OK</span>");
                } else {
                    html.append("<span class='error'>❌ ERROR</span>");
                }
                html.append("</td>");
                html.append("</tr>");
                
                // Añadir fila con detalle por origen
                if (!conteoPorOrigen.isEmpty()) {
                    html.append("<tr>");
                    html.append("<td colspan='9' style='padding-left: 30px; background-color: #f8f9fa;'>");
                    html.append("<small><strong>Detalle por Sucursal (COD_ORIGEN):</strong></small>");
                    html.append("<table class='origen-table' style='width: auto; margin-left: 20px;'>");
                    
                    for (Map.Entry<String, Long[]> origenEntry : conteoPorOrigen.entrySet()) {
                        String origen = origenEntry.getKey();
                        Long localCount = origenEntry.getValue()[0];
                        Long remoteCount = origenEntry.getValue()[1];
                        long diff = localCount - remoteCount;
                        
                        html.append("<tr>");
                        html.append("<td><strong>").append(origen).append(":</strong></td>");
                        html.append("<td>Local: ").append(localCount).append("</td>");
                        html.append("<td>Remoto: ").append(remoteCount).append("</td>");
                        html.append("<td>");
                        if (diff == 0) {
                            html.append("<span class='success'>✓ Sincronizado</span>");
                        } else if (diff > 0) {
                            html.append("<span class='warning'>+" + diff + " pendientes</span>");
                        } else {
                            html.append("<span class='error'>" + diff + " faltantes</span>");
                        }
                        html.append("</td>");
                        html.append("</tr>");
                    }
                    
                    html.append("</table>");
                    html.append("</td>");
                    html.append("</tr>");
                }
            } else {
                // Para las demás tablas, mostrar normal
                html.append("<tr class='").append(countLocal == countRemote ? "stats-equal" : "stats-diff").append("'>");
                html.append("<td><strong>").append(stats.getNombreTabla()).append("</strong></td>");
                html.append("<td>").append(stats.getDireccion().equals("REMOTE_TO_LOCAL") ? "Oracle → PostgreSQL" : "PostgreSQL → Oracle").append("</td>");
                html.append("<td>").append(stats.getRegistrosInsertados()).append("</td>");
                html.append("<td>").append(stats.getRegistrosActualizados()).append("</td>");
                html.append("<td>").append(stats.getRegistrosEliminados()).append("</td>");
                html.append("<td>").append(stats.getRegistrosErrores() > 0 ? "<span class='error'>" + stats.getRegistrosErrores() + "</span>" : "0").append("</td>");
                html.append("<td>").append(countLocal).append("</td>");
                html.append("<td>").append(countRemote).append("</td>");
                html.append("<td>");
                if (stats.isExitoso()) {
                    html.append("<span class='success'>✅ OK</span>");
                } else {
                    html.append("<span class='error'>❌ ERROR</span>");
                }
                if (countLocal != countRemote) {
                    html.append(" <span class='warning'>⚠️ Diferencia</span>");
                }
                html.append("</td>");
                html.append("</tr>");
            }
        }
        
        html.append("</tbody>");
        html.append("</table>");
        
        // Tabla de errores si los hay
        if (!report.getErrores().isEmpty()) {
            html.append("<h2>⚠️ Errores Encontrados</h2>");
            html.append("<table>");
            html.append("<thead>");
            html.append("<tr>");
            html.append("<th>Tabla</th>");
            html.append("<th>Descripción del Error</th>");
            html.append("<th>Registro ID</th>");
            html.append("<th>Línea/Stack</th>");
            html.append("</tr>");
            html.append("</thead>");
            html.append("<tbody>");
            
            for (String error : report.getErrores()) {
                html.append("<tr>");
                String tabla = extraerTabla(error);
                String descripcion = extraerDescripcion(error);
                String registroId = extraerRegistroId(error);
                String linea = extraerLinea(error);
                
                html.append("<td>").append(tabla).append("</td>");
                html.append("<td class='error'>").append(descripcion).append("</td>");
                html.append("<td>").append(registroId).append("</td>");
                html.append("<td><small>").append(linea).append("</small></td>");
                html.append("</tr>");
            }
            
            html.append("</tbody>");
            html.append("</table>");
        }
        
        // Tabla de estadísticas de los últimos 7 días SOLO para asistencia_ht580
        html.append("<h2>📈 Estadísticas de Asistencia - Últimos ").append(diasEstadisticas).append(" Días</h2>");
        html.append("<table>");
        html.append("<thead>");
        html.append("<tr>");
        html.append("<th>Fecha</th>");
        html.append("<th>Sucursal</th>");
        html.append("<th>Registros BD Local</th>");
        html.append("<th>Registros BD Remota</th>");
        html.append("<th>Diferencia</th>");
        html.append("</tr>");
        html.append("</thead>");
        html.append("<tbody>");
        
        // Generar estadísticas REALES solo para asistencia_ht580
        List<EstadisticaDiaria> estadisticas = generarEstadisticasAsistenciaUltimosDias();
        for (EstadisticaDiaria est : estadisticas) {
            html.append("<tr>");
            html.append("<td>").append(est.getFecha().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))).append("</td>");
            html.append("<td>").append(est.getCodOrigen() != null ? est.getCodOrigen() : "TOTAL").append("</td>");
            html.append("<td>").append(est.getRegistrosLocal()).append("</td>");
            html.append("<td>").append(est.getRegistrosRemoto()).append("</td>");
            long diferencia = est.getRegistrosLocal() - est.getRegistrosRemoto();
            html.append("<td class='").append(diferencia == 0 ? "success" : "warning").append("'>");
            if (diferencia > 0) {
                html.append("+").append(diferencia);
            } else if (diferencia < 0) {
                html.append(diferencia);
            } else {
                html.append("✓");
            }
            html.append("</td>");
            html.append("</tr>");
        }
        
        html.append("</tbody>");
        html.append("</table>");
        
        // Consolidado de registros con error persistente en BD
        agregarSeccionErroresPersistentes(html);

        // Pie de página
        html.append("<div class='footer'>");
        html.append("<p><strong>Sistema SIGRE - Módulo de Asistencia</strong></p>");
        html.append("<p>Transmarina del PERU SAC</p>");
        html.append("<p style='font-size: 12px; color: #95a5a6;'>Este es un reporte automático generado por el sistema de sincronización</p>");
        html.append("</div>");
        
        html.append("</div>");
        html.append("</body>");
        html.append("</html>");
        
        return html.toString();
    }
    
    /**
     * Obtener conteos actuales de registros en cada tabla
     */
    private Map<String, Long[]> obtenerConteosActuales() {
        Map<String, Long[]> conteos = new HashMap<>();
        
        try {
            // Para maestro, centros_costo y tarjetas: conteo normal
            conteos.put("maestro", new Long[]{maestroLocalRepo.count(), maestroRemoteRepo.count()});
            conteos.put("centros_costo", new Long[]{centrosLocalRepo.count(), centrosRemoteRepo.count()});
            conteos.put("rrhh_asigna_trjt_reloj", new Long[]{tarjetasLocalRepo.count(), tarjetasRemoteRepo.count()});
            
            // Para asistencia: contar solo los registros que corresponden a los códigos de origen locales
            long countAsistenciaLocal = asistenciaLocalRepo.count();
            
            // Obtener códigos de origen de la BD local
            Set<String> codigosOrigen = obtenerCodigosOrigenLocal();
            long countAsistenciaRemote = 0;
            
            if (!codigosOrigen.isEmpty()) {
                // Construir consulta con filtro de códigos de origen
                StringBuilder placeholders = new StringBuilder();
                for (int i = 0; i < codigosOrigen.size(); i++) {
                    if (i > 0) placeholders.append(",");
                    placeholders.append("?");
                }
                
                String sqlRemote = "SELECT COUNT(*) FROM asistencia_ht580 WHERE COD_ORIGEN IN (" + placeholders + ")";
                countAsistenciaRemote = jdbcTemplateRemote.queryForObject(sqlRemote, Long.class, codigosOrigen.toArray());
                
                log.info("📊 Conteo asistencia con filtro por origen {}: Local={}, Remoto={}", 
                        codigosOrigen, countAsistenciaLocal, countAsistenciaRemote);
            } 
            
            conteos.put("asistencia_ht580", new Long[]{countAsistenciaLocal, countAsistenciaRemote});
            
        } catch (Exception e) {
            log.error("Error obteniendo conteos de registros", e);
        }
        
        return conteos;
    }
    
    /**
     * Obtener conteo de asistencia por código de origen
     */
    private Map<String, Long[]> obtenerConteoAsistenciaPorOrigen() {
        Map<String, Long[]> conteoPorOrigen = new TreeMap<>(); // TreeMap para ordenar por código
        
        try {
            // Obtener los códigos de origen de la BD local
            Set<String> codigosOrigen = obtenerCodigosOrigenLocal();
            
            for (String codOrigen : codigosOrigen) {
                // Conteo en BD Local
                String sqlLocal = "SELECT COUNT(*) FROM asistencia_ht580 WHERE COD_ORIGEN = ?";
                Long countLocal = jdbcTemplateLocal.queryForObject(sqlLocal, Long.class, codOrigen);
                
                // Conteo en BD Remota con el mismo filtro
                String sqlRemote = "SELECT COUNT(*) FROM asistencia_ht580 WHERE COD_ORIGEN = ?";
                Long countRemote = jdbcTemplateRemote.queryForObject(sqlRemote, Long.class, codOrigen);
                
                conteoPorOrigen.put(codOrigen, new Long[]{countLocal, countRemote});
                
                log.info("📊 Asistencia para origen {}: Local={}, Remoto={}", 
                        codOrigen, countLocal, countRemote);
            }
            
        } catch (Exception e) {
            log.error("Error obteniendo conteo de asistencia por origen", e);
        }
        
        return conteoPorOrigen;
    }
    
    /**
     * Generar estadísticas REALES de asistencia de los últimos días agrupadas por origen
     */
    private List<EstadisticaDiaria> generarEstadisticasAsistenciaUltimosDias() {
        List<EstadisticaDiaria> estadisticas = new ArrayList<>();
        
        try {
            // Obtener los códigos de origen activos
            Set<String> codigosOrigen = obtenerCodigosOrigenLocal();
            
            for (String codOrigen : codigosOrigen) {
                // Consulta para PostgreSQL (BD Local) filtrada por origen
                String sqlAsistenciaLocal = """
                    SELECT DATE(DATE_TRUNC('day', FEC_MOVIMIENTO)) as fecha, COUNT(*) as cantidad
                    FROM asistencia_ht580
                    WHERE COD_ORIGEN = ?
                    AND FEC_MOVIMIENTO >= CURRENT_DATE - INTERVAL '%d days'
                    GROUP BY DATE(DATE_TRUNC('day', FEC_MOVIMIENTO))
                    ORDER BY fecha DESC
                    """.formatted(diasEstadisticas);
                
                Map<LocalDate, Long> asistenciaLocalPorFecha = new HashMap<>();
                jdbcTemplateLocal.query(sqlAsistenciaLocal, 
                    new Object[]{codOrigen},
                    (rs) -> {
                        LocalDate fecha = rs.getDate("fecha").toLocalDate();
                        Long cantidad = rs.getLong("cantidad");
                        asistenciaLocalPorFecha.put(fecha, cantidad);
                    });
                
                // Consulta para Oracle (BD Remota) filtrada por origen
                String sqlAsistenciaRemote = """
                    SELECT TRUNC(FEC_MOVIMIENTO) as fecha, COUNT(*) as cantidad
                    FROM asistencia_ht580
                    WHERE COD_ORIGEN = :origen
                    AND FEC_MOVIMIENTO >= TRUNC(SYSDATE) - %d
                    GROUP BY TRUNC(FEC_MOVIMIENTO)
                    ORDER BY fecha DESC
                    """.formatted(diasEstadisticas);
                
                Map<LocalDate, Long> asistenciaRemotePorFecha = new HashMap<>();
                jdbcTemplateRemote.query(sqlAsistenciaRemote.replace(":origen", "?"),
                    new Object[]{codOrigen},
                    (rs) -> {
                        LocalDate fecha = rs.getDate("fecha").toLocalDate();
                        Long cantidad = rs.getLong("cantidad");
                        asistenciaRemotePorFecha.put(fecha, cantidad);
                    });
                
                // Combinar resultados
                Set<LocalDate> todasLasFechas = new HashSet<>();
                todasLasFechas.addAll(asistenciaLocalPorFecha.keySet());
                todasLasFechas.addAll(asistenciaRemotePorFecha.keySet());
                
                for (LocalDate fecha : todasLasFechas) {
                    EstadisticaDiaria est = new EstadisticaDiaria();
                    est.setNombreTabla("asistencia_ht580");
                    est.setCodOrigen(codOrigen);
                    est.setFecha(fecha);
                    est.setRegistrosLocal(asistenciaLocalPorFecha.getOrDefault(fecha, 0L));
                    est.setRegistrosRemoto(asistenciaRemotePorFecha.getOrDefault(fecha, 0L));
                    estadisticas.add(est);
                }
            }
            
            // Agregar también un total por fecha (SOLO de los códigos de origen que están en local)
            if (!codigosOrigen.isEmpty()) {
                // Total en Local
                String sqlTotalLocal = """
                    SELECT DATE(DATE_TRUNC('day', FEC_MOVIMIENTO)) as fecha, COUNT(*) as cantidad
                    FROM asistencia_ht580
                    WHERE FEC_MOVIMIENTO >= CURRENT_DATE - INTERVAL '%d days'
                    GROUP BY DATE(DATE_TRUNC('day', FEC_MOVIMIENTO))
                    ORDER BY fecha DESC
                    """.formatted(diasEstadisticas);
                
                Map<LocalDate, Long> totalLocalPorFecha = new HashMap<>();
                jdbcTemplateLocal.query(sqlTotalLocal, (rs) -> {
                    LocalDate fecha = rs.getDate("fecha").toLocalDate();
                    Long cantidad = rs.getLong("cantidad");
                    totalLocalPorFecha.put(fecha, cantidad);
                });
                
                // Total en Remoto (filtrado por los códigos de origen de local)
                StringBuilder placeholders = new StringBuilder();
                for (int i = 0; i < codigosOrigen.size(); i++) {
                    if (i > 0) placeholders.append(",");
                    placeholders.append("?");
                }
                
                String sqlTotalRemote = """
                    SELECT TRUNC(FEC_MOVIMIENTO) as fecha, COUNT(*) as cantidad
                    FROM asistencia_ht580
                    WHERE COD_ORIGEN IN (%s)
                    AND FEC_MOVIMIENTO >= TRUNC(SYSDATE) - %d
                    GROUP BY TRUNC(FEC_MOVIMIENTO)
                    ORDER BY fecha DESC
                    """.formatted(placeholders.toString(), diasEstadisticas);
                
                Map<LocalDate, Long> totalRemotePorFecha = new HashMap<>();
                jdbcTemplateRemote.query(sqlTotalRemote, 
                    codigosOrigen.toArray(),
                    (rs) -> {
                        LocalDate fecha = rs.getDate("fecha").toLocalDate();
                        Long cantidad = rs.getLong("cantidad");
                        totalRemotePorFecha.put(fecha, cantidad);
                    });
                
                // Agregar totales
                Set<LocalDate> fechasTotales = new HashSet<>();
                fechasTotales.addAll(totalLocalPorFecha.keySet());
                fechasTotales.addAll(totalRemotePorFecha.keySet());
                
                for (LocalDate fecha : fechasTotales) {
                    EstadisticaDiaria est = new EstadisticaDiaria();
                    est.setNombreTabla("asistencia_ht580");
                    est.setCodOrigen("TOTAL");
                    est.setFecha(fecha);
                    est.setRegistrosLocal(totalLocalPorFecha.getOrDefault(fecha, 0L));
                    est.setRegistrosRemoto(totalRemotePorFecha.getOrDefault(fecha, 0L));
                    estadisticas.add(est);
                }
            }
            
        } catch (Exception e) {
            log.error("Error ejecutando consultas para estadísticas de asistencia", e);
        }
        
        // Ordenar por fecha descendente y luego por código de origen
        estadisticas.sort((a, b) -> {
            int fechaComp = b.getFecha().compareTo(a.getFecha());
            if (fechaComp != 0) return fechaComp;
            
            // TOTAL siempre al final de cada fecha
            if ("TOTAL".equals(a.getCodOrigen())) return 1;
            if ("TOTAL".equals(b.getCodOrigen())) return -1;
            
            return a.getCodOrigen().compareTo(b.getCodOrigen());
        });
        
        return estadisticas;
    }
    
    /**
     * Agregar sección con consolidado de registros que tienen estado_sync = 'E' en la BD local.
     * Muestra: mensaje de error agrupado + cantidad de registros afectados.
     */
    private void agregarSeccionErroresPersistentes(StringBuilder html) {
        try {
            String sqlErrores = """
                SELECT 
                    COALESCE(observaciones, 'Error de conexión con Oracle') AS mensaje_error,
                    COUNT(*) AS cantidad,
                    MIN(fec_registro) AS primer_registro,
                    MAX(fecha_sync) AS ultimo_intento,
                    MAX(intentos_sync) AS max_intentos
                FROM asistencia_ht580
                WHERE estado_sync = 'E'
                  AND external_id IS NULL
                GROUP BY COALESCE(observaciones, 'Error de conexión con Oracle')
                ORDER BY cantidad DESC
                """;

            List<Map<String, Object>> errores = jdbcTemplateLocal.queryForList(sqlErrores);

            if (errores.isEmpty()) {
                return;
            }

            long totalRegistrosError = errores.stream()
                    .mapToLong(e -> ((Number) e.get("cantidad")).longValue())
                    .sum();

            html.append("<h2>🔴 Registros con Error Pendiente de Sincronización (").append(totalRegistrosError).append(" total)</h2>");
            html.append("<p style='color: #7f8c8d;'>Estos registros se reintentan automáticamente cada 6 horas</p>");
            html.append("<table>");
            html.append("<thead>");
            html.append("<tr>");
            html.append("<th style='background-color: #e74c3c;'>Mensaje de Error</th>");
            html.append("<th style='background-color: #e74c3c;'>Registros</th>");
            html.append("<th style='background-color: #e74c3c;'>Primer Registro</th>");
            html.append("<th style='background-color: #e74c3c;'>Último Intento</th>");
            html.append("<th style='background-color: #e74c3c;'>Max Intentos</th>");
            html.append("</tr>");
            html.append("</thead>");
            html.append("<tbody>");

            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

            for (Map<String, Object> error : errores) {
                String mensaje = (String) error.get("mensaje_error");
                long cantidad = ((Number) error.get("cantidad")).longValue();
                Object primerReg = error.get("primer_registro");
                Object ultimoIntento = error.get("ultimo_intento");
                Object maxIntentos = error.get("max_intentos");

                html.append("<tr>");
                html.append("<td class='error'>").append(mensaje != null && mensaje.length() > 120 ? mensaje.substring(0, 120) + "..." : mensaje).append("</td>");
                html.append("<td style='text-align: center; font-weight: bold;'>").append(cantidad).append("</td>");
                html.append("<td>").append(primerReg != null ? primerReg.toString().substring(0, Math.min(16, primerReg.toString().length())) : "-").append("</td>");
                html.append("<td>").append(ultimoIntento != null ? ultimoIntento.toString().substring(0, Math.min(16, ultimoIntento.toString().length())) : "Nunca").append("</td>");
                html.append("<td style='text-align: center;'>").append(maxIntentos != null ? maxIntentos : 0).append("</td>");
                html.append("</tr>");
            }

            html.append("</tbody>");
            html.append("</table>");

        } catch (Exception e) {
            log.error("Error generando sección de errores persistentes para email", e);
        }
    }

    // Métodos auxiliares para parsear errores
    private String extraerTabla(String error) {
        if (error.contains("maestro")) return "maestro";
        if (error.contains("centros_costo")) return "centros_costo";
        if (error.contains("asistencia")) return "asistencia_ht580";
        if (error.contains("tarjeta") || error.contains("rrhh")) return "rrhh_asigna_trjt_reloj";
        return "Desconocida";
    }
    
    private String extraerDescripcion(String error) {
        int idx = error.indexOf(":");
        if (idx > 0 && idx < error.length() - 1) {
            return error.substring(idx + 1).trim();
        }
        return error.length() > 100 ? error.substring(0, 100) + "..." : error;
    }
    
    private String extraerRegistroId(String error) {
        String[] parts = error.split(" ");
        for (int i = 0; i < parts.length - 1; i++) {
            if (parts[i].equals("trabajador") || parts[i].equals("asistencia") || 
                parts[i].equals("centro") || parts[i].equals("tarjeta")) {
                return parts[i + 1].replaceAll("[^a-zA-Z0-9]", "");
            }
        }
        return "-";
    }
    
    private String extraerLinea(String error) {
        if (error.contains("at ")) {
            int idx = error.indexOf("at ");
            int end = error.indexOf(")", idx);
            if (end > idx) {
                return error.substring(idx, Math.min(end + 1, idx + 50));
            }
        }
        return "-";
    }
    
    // Clases internas
    @lombok.Data
    private static class EstadisticaDiaria {
        private String nombreTabla;
        private String codOrigen;
        private LocalDate fecha;
        private long registrosLocal;
        private long registrosRemoto;
    }
    
    // DTOs
    @lombok.Data
    @lombok.Builder
    public static class SyncReport {
        private LocalDateTime fechaHora;
        private long duracionMinutos;
        private boolean exitoso;
        private boolean remoteToLocalExitoso;
        private boolean localToRemoteExitoso;
        private Map<String, Integer> tablasSincronizadasRemoteToLocal;
        private Map<String, Integer> tablasSincronizadasLocalToRemote;
        private Map<String, SyncTableStats> estadisticasDetalladas;
        private List<String> errores;
        private LocalDateTime proximaSincronizacion;
    }
    
    @lombok.Data
    @lombok.Builder
    public static class SyncTableStats {
        private String nombreTabla;
        private int registrosInsertados;
        private int registrosActualizados;
        private int registrosEliminados;
        private int registrosErrores;
        private String direccion;
        private String baseOrigen;
        private String baseDestino;
        private long duracionMs;
        private boolean exitoso;
    }
}