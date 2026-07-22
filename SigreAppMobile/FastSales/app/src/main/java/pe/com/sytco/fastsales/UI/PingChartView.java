package pe.com.sytco.fastsales.UI;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.View;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.beans.BeanPingHistory;

/**
 * Vista personalizada para graficar pings en tiempo real
 * Soporta múltiples líneas (latencia total, conexión BD, query BD)
 */
public class PingChartView extends View {
    
    // Modos de visualización
    public static final int MODE_TOTAL_LATENCY = 0;      // Solo latencia total
    public static final int MODE_DATABASE_TIMES = 1;      // Conexión BD + Query BD
    
    private int displayMode = MODE_TOTAL_LATENCY;
    
    private List<BeanPingHistory> pingData;
    
    // Paints para líneas
    private Paint lineTotalPaint;      // Verde para latencia total
    private Paint lineDbConnectionPaint; // Azul para conexión BD
    private Paint lineDbQueryPaint;     // Naranja para query BD
    
    // Paints auxiliares
    private Paint gridPaint;
    private Paint textPaint;
    private Paint successPaint;
    private Paint failurePaint;
    
    // Paths para las líneas
    private Path pathTotal;
    private Path pathDbConnection;
    private Path pathDbQuery;
    
    private float maxLatency = 200; // Latencia máxima para escala (ms)
    private int padding = 60;
    
    public PingChartView(Context context) {
        super(context);
        init();
    }
    
    public PingChartView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }
    
    public PingChartView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }
    
    private void init() {
        pingData = new ArrayList<>();
        
        // Paint para línea de latencia total (verde)
        lineTotalPaint = new Paint();
        lineTotalPaint.setColor(Color.parseColor("#4CAF50")); // Verde
        lineTotalPaint.setStrokeWidth(4f);
        lineTotalPaint.setStyle(Paint.Style.STROKE);
        lineTotalPaint.setAntiAlias(true);
        
        // Paint para línea de conexión BD (azul)
        lineDbConnectionPaint = new Paint();
        lineDbConnectionPaint.setColor(Color.parseColor("#2196F3")); // Azul
        lineDbConnectionPaint.setStrokeWidth(4f);
        lineDbConnectionPaint.setStyle(Paint.Style.STROKE);
        lineDbConnectionPaint.setAntiAlias(true);
        
        // Paint para línea de query BD (naranja)
        lineDbQueryPaint = new Paint();
        lineDbQueryPaint.setColor(Color.parseColor("#FF9800")); // Naranja
        lineDbQueryPaint.setStrokeWidth(4f);
        lineDbQueryPaint.setStyle(Paint.Style.STROKE);
        lineDbQueryPaint.setAntiAlias(true);
        
        // Paint para la cuadrícula
        gridPaint = new Paint();
        gridPaint.setColor(Color.LTGRAY);
        gridPaint.setStrokeWidth(1f);
        gridPaint.setStyle(Paint.Style.STROKE);
        gridPaint.setAntiAlias(true);
        
        // Paint para texto
        textPaint = new Paint();
        textPaint.setColor(Color.DKGRAY);
        textPaint.setTextSize(16f); // Reducido de 22f a 16f para que no sean tan grandes
        textPaint.setAntiAlias(true);
        
        // Paint para puntos exitosos
        successPaint = new Paint();
        successPaint.setColor(Color.parseColor("#4CAF50"));
        successPaint.setStyle(Paint.Style.FILL);
        successPaint.setAntiAlias(true);
        
        // Paint para puntos fallidos
        failurePaint = new Paint();
        failurePaint.setColor(Color.parseColor("#F44336"));
        failurePaint.setStyle(Paint.Style.FILL);
        failurePaint.setAntiAlias(true);
        
        // Paths para las líneas
        pathTotal = new Path();
        pathDbConnection = new Path();
        pathDbQuery = new Path();
    }
    
    /**
     * Establece el modo de visualización
     */
    public void setDisplayMode(int mode) {
        this.displayMode = mode;
        invalidate();
    }
    
    /**
     * Obtiene el modo de visualización actual
     */
    public int getDisplayMode() {
        return displayMode;
    }
    
    public void setPingData(List<BeanPingHistory> data) {
        this.pingData = data != null ? new ArrayList<>(data) : new ArrayList<BeanPingHistory>();
        
        // Ajustar escala máxima basándose en los datos
        adjustMaxLatency();
        
        // Log de diagnóstico
        if (displayMode == MODE_DATABASE_TIMES) {
            int countWithData = 0;
            for (BeanPingHistory ping : pingData) {
                if (ping.getDbConnectionMs() != null || ping.getDbQueryMs() != null) {
                    countWithData++;
                }
            }
            android.util.Log.i("PingChartView", String.format(
                "Modo BD: %d registros totales, %d con datos BD, maxLatency=%.0fms", 
                pingData.size(), countWithData, maxLatency));
        }
        
        invalidate(); // Redibujar
    }
    
    private void adjustMaxLatency() {
        float maxFound = 0;
        
        if (displayMode == MODE_TOTAL_LATENCY) {
            // Para latencia total
            for (BeanPingHistory ping : pingData) {
                if (ping.isSuccess() && ping.getLatencyMs() != null) {
                    maxFound = Math.max(maxFound, ping.getLatencyMs());
                }
            }
        } else if (displayMode == MODE_DATABASE_TIMES) {
            // Para tiempos de BD, buscar el máximo entre conexión y query
            for (BeanPingHistory ping : pingData) {
                if (ping.isSuccess()) {
                    if (ping.getDbConnectionMs() != null) {
                        maxFound = Math.max(maxFound, ping.getDbConnectionMs());
                    }
                    if (ping.getDbQueryMs() != null) {
                        maxFound = Math.max(maxFound, ping.getDbQueryMs());
                    }
                }
            }
        }
        
        // Ajustar con un margen del 20%
        maxLatency = maxFound * 1.2f;
        if (maxLatency < 100) maxLatency = 100; // Mínimo 100ms
    }
    
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        
        if (pingData == null || pingData.isEmpty()) {
            // Mostrar mensaje "Sin datos"
            canvas.drawText("Sin datos", getWidth() / 2f - 50, getHeight() / 2f, textPaint);
            return;
        }
        
        float width = getWidth() - (2 * padding);
        float height = getHeight() - (2 * padding);
        
        // Dibujar cuadrícula
        drawGrid(canvas, width, height);
        
        // Dibujar datos
        drawData(canvas, width, height);
    }
    
    private void drawGrid(Canvas canvas, float width, float height) {
        // Líneas horizontales (latencia)
        int horizontalLines = 5;
        for (int i = 0; i <= horizontalLines; i++) {
            float y = padding + (height * i / horizontalLines);
            canvas.drawLine(padding, y, padding + width, y, gridPaint);
            
            // Etiquetas de latencia
            float latency = maxLatency * (1 - (float)i / horizontalLines);
            canvas.drawText(String.format("%.0fms", latency), 5, y + 5, textPaint);
        }
        
        // Líneas verticales (tiempo) - espaciado inteligente según cantidad de datos
        int dataPoints = pingData.size();
        int gridSpacing; // Cada cuántos puntos dibujamos una línea vertical
        
        if (dataPoints <= 20) {
            gridSpacing = 2; // Cada 2 puntos (10 líneas para 20 puntos)
        } else if (dataPoints <= 50) {
            gridSpacing = 5; // Cada 5 puntos (10 líneas para 50 puntos)
        } else {
            gridSpacing = 10; // Cada 10 puntos (10 líneas para 100 puntos)
        }
        
        // Dibujar líneas verticales espaciadas
        for (int i = 0; i < dataPoints; i += gridSpacing) {
            float x = padding + (width * i / Math.max(1, dataPoints - 1));
            canvas.drawLine(x, padding, x, padding + height, gridPaint);
        }
        
        // Siempre dibujar la última línea vertical
        if (dataPoints > 0) {
            float lastX = padding + width;
            canvas.drawLine(lastX, padding, lastX, padding + height, gridPaint);
        }
    }
    
    private void drawData(Canvas canvas, float width, float height) {
        int dataSize = pingData.size();
        if (dataSize == 0) return;
        
        float xStep = width / Math.max(1, dataSize - 1);
        
        if (displayMode == MODE_TOTAL_LATENCY) {
            // Dibujar solo latencia total (línea verde)
            drawTotalLatencyLine(canvas, width, height, xStep);
        } else if (displayMode == MODE_DATABASE_TIMES) {
            // Dibujar dos líneas: conexión BD (azul) y query BD (naranja)
            drawDatabaseTimesLines(canvas, width, height, xStep);
        }
    }
    
    /**
     * Dibuja la línea de latencia total
     */
    private void drawTotalLatencyLine(Canvas canvas, float width, float height, float xStep) {
        pathTotal.reset();
        
        int dataSize = pingData.size();
        boolean firstPoint = true;
        
        for (int i = 0; i < dataSize; i++) {
            BeanPingHistory ping = pingData.get(i);
            float x = padding + (i * xStep);
            
            if (ping.isSuccess() && ping.getLatencyMs() != null) {
                // Calcular Y basándose en la latencia total
                float latencyRatio = Math.min(1f, ping.getLatencyMs() / maxLatency);
                float y = padding + height - (latencyRatio * height);
                
                // Agregar punto a la línea
                if (firstPoint) {
                    pathTotal.moveTo(x, y);
                    firstPoint = false;
                } else {
                    pathTotal.lineTo(x, y);
                }
                
                // Dibujar punto exitoso
                canvas.drawCircle(x, y, 5, successPaint);
            } else {
                // Dibujar punto fallido en la parte inferior
                float y = padding + height;
                canvas.drawCircle(x, y, 5, failurePaint);
            }
        }
        
        // Dibujar la línea verde de latencia total
        canvas.drawPath(pathTotal, lineTotalPaint);
    }
    
    /**
     * Dibuja las líneas de tiempos de base de datos (conexión y query)
     */
    private void drawDatabaseTimesLines(Canvas canvas, float width, float height, float xStep) {
        pathDbConnection.reset();
        pathDbQuery.reset();
        
        int dataSize = pingData.size();
        boolean firstDbConnectionPoint = true;
        boolean firstDbQueryPoint = true;
        
        for (int i = 0; i < dataSize; i++) {
            BeanPingHistory ping = pingData.get(i);
            float x = padding + (i * xStep);
            
            if (ping.isSuccess()) {
                // Dibujar línea de conexión BD (azul)
                if (ping.getDbConnectionMs() != null) {
                    float dbConnectionRatio = Math.min(1f, ping.getDbConnectionMs() / maxLatency);
                    float yDbConnection = padding + height - (dbConnectionRatio * height);
                    
                    if (firstDbConnectionPoint) {
                        pathDbConnection.moveTo(x, yDbConnection);
                        firstDbConnectionPoint = false;
                    } else {
                        pathDbConnection.lineTo(x, yDbConnection);
                    }
                    
                    // Dibujar punto azul para conexión BD
                    canvas.drawCircle(x, yDbConnection, 4, lineDbConnectionPaint);
                }
                
                // Dibujar línea de query BD (naranja)
                if (ping.getDbQueryMs() != null) {
                    float dbQueryRatio = Math.min(1f, ping.getDbQueryMs() / maxLatency);
                    float yDbQuery = padding + height - (dbQueryRatio * height);
                    
                    if (firstDbQueryPoint) {
                        pathDbQuery.moveTo(x, yDbQuery);
                        firstDbQueryPoint = false;
                    } else {
                        pathDbQuery.lineTo(x, yDbQuery);
                    }
                    
                    // Dibujar punto naranja para query BD
                    canvas.drawCircle(x, yDbQuery, 4, lineDbQueryPaint);
                }
            } else {
                // Dibujar punto fallido en la parte inferior
                float y = padding + height;
                canvas.drawCircle(x, y, 5, failurePaint);
            }
        }
        
        // Dibujar las líneas
        canvas.drawPath(pathDbConnection, lineDbConnectionPaint); // Línea azul
        canvas.drawPath(pathDbQuery, lineDbQueryPaint);           // Línea naranja
    }
}

