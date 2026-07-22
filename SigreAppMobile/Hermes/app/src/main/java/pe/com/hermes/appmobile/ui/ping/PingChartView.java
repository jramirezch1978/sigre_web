package pe.com.hermes.appmobile.ui.ping;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.View;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.data.ping.PingSample;

/** Vista Canvas para gráficas de ping — port de FastSales PingChartView. */
public class PingChartView extends View {

    public static final int MODE_TOTAL_LATENCY = 0;
    public static final int MODE_DATABASE_TIMES = 1;

    private int displayMode = MODE_TOTAL_LATENCY;
    private List<PingSample> pingData = new ArrayList<>();

    private Paint lineTotalPaint;
    private Paint lineDbConnectionPaint;
    private Paint lineDbQueryPaint;
    private Paint gridPaint;
    private Paint textPaint;
    private Paint successPaint;
    private Paint failurePaint;
    private Path pathTotal;
    private Path pathDbConnection;
    private Path pathDbQuery;

    private float maxLatency = 200;
    private final int padding = 60;

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
        lineTotalPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        lineTotalPaint.setColor(Color.parseColor("#4CAF50"));
        lineTotalPaint.setStrokeWidth(4f);
        lineTotalPaint.setStyle(Paint.Style.STROKE);

        lineDbConnectionPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        lineDbConnectionPaint.setColor(Color.parseColor("#2196F3"));
        lineDbConnectionPaint.setStrokeWidth(4f);
        lineDbConnectionPaint.setStyle(Paint.Style.STROKE);

        lineDbQueryPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        lineDbQueryPaint.setColor(Color.parseColor("#FF9800"));
        lineDbQueryPaint.setStrokeWidth(4f);
        lineDbQueryPaint.setStyle(Paint.Style.STROKE);

        gridPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        gridPaint.setColor(Color.LTGRAY);
        gridPaint.setStrokeWidth(1f);
        gridPaint.setStyle(Paint.Style.STROKE);

        textPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        textPaint.setColor(Color.DKGRAY);
        textPaint.setTextSize(16f);

        successPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        successPaint.setColor(Color.parseColor("#4CAF50"));
        successPaint.setStyle(Paint.Style.FILL);

        failurePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        failurePaint.setColor(Color.parseColor("#F44336"));
        failurePaint.setStyle(Paint.Style.FILL);

        pathTotal = new Path();
        pathDbConnection = new Path();
        pathDbQuery = new Path();
    }

    public void setDisplayMode(int mode) {
        this.displayMode = mode;
        invalidate();
    }

    public void setPingData(List<PingSample> data) {
        this.pingData = data != null ? new ArrayList<>(data) : new ArrayList<>();
        adjustMaxLatency();
        invalidate();
    }

    private void adjustMaxLatency() {
        float maxFound = 0;
        for (PingSample ping : pingData) {
            if (!ping.isSuccess()) continue;
            if (displayMode == MODE_TOTAL_LATENCY && ping.getLatencyMs() != null) {
                maxFound = Math.max(maxFound, ping.getLatencyMs());
            } else if (displayMode == MODE_DATABASE_TIMES) {
                if (ping.getDbConnectionMs() != null) maxFound = Math.max(maxFound, ping.getDbConnectionMs());
                if (ping.getDbQueryMs() != null) maxFound = Math.max(maxFound, ping.getDbQueryMs());
            }
        }
        maxLatency = Math.max(100f, maxFound * 1.2f);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (pingData == null || pingData.isEmpty()) {
            canvas.drawText("Sin datos", getWidth() / 2f - 50, getHeight() / 2f, textPaint);
            return;
        }
        float width = getWidth() - (2f * padding);
        float height = getHeight() - (2f * padding);
        drawGrid(canvas, width, height);
        drawData(canvas, width, height);
    }

    private void drawGrid(Canvas canvas, float width, float height) {
        int horizontalLines = 5;
        for (int i = 0; i <= horizontalLines; i++) {
            float y = padding + (height * i / horizontalLines);
            canvas.drawLine(padding, y, padding + width, y, gridPaint);
            float latency = maxLatency * (1 - (float) i / horizontalLines);
            canvas.drawText(String.format("%.0fms", latency), 5, y + 5, textPaint);
        }
        int dataPoints = pingData.size();
        int gridSpacing = dataPoints <= 20 ? 2 : (dataPoints <= 50 ? 5 : 10);
        for (int i = 0; i < dataPoints; i += gridSpacing) {
            float x = padding + (width * i / Math.max(1, dataPoints - 1));
            canvas.drawLine(x, padding, x, padding + height, gridPaint);
        }
        if (dataPoints > 0) {
            canvas.drawLine(padding + width, padding, padding + width, padding + height, gridPaint);
        }
    }

    private void drawData(Canvas canvas, float width, float height) {
        int dataSize = pingData.size();
        if (dataSize == 0) return;
        float xStep = width / Math.max(1, dataSize - 1);
        if (displayMode == MODE_TOTAL_LATENCY) {
            drawTotalLatencyLine(canvas, height, xStep);
        } else {
            drawDatabaseTimesLines(canvas, height, xStep);
        }
    }

    private void drawTotalLatencyLine(Canvas canvas, float height, float xStep) {
        pathTotal.reset();
        boolean first = true;
        for (int i = 0; i < pingData.size(); i++) {
            PingSample ping = pingData.get(i);
            float x = padding + (i * xStep);
            if (ping.isSuccess() && ping.getLatencyMs() != null) {
                float y = padding + height - (Math.min(1f, ping.getLatencyMs() / maxLatency) * height);
                if (first) {
                    pathTotal.moveTo(x, y);
                    first = false;
                } else {
                    pathTotal.lineTo(x, y);
                }
                canvas.drawCircle(x, y, 5, successPaint);
            } else {
                canvas.drawCircle(x, padding + height, 5, failurePaint);
            }
        }
        canvas.drawPath(pathTotal, lineTotalPaint);
    }

    private void drawDatabaseTimesLines(Canvas canvas, float height, float xStep) {
        pathDbConnection.reset();
        pathDbQuery.reset();
        boolean firstConn = true;
        boolean firstQuery = true;
        for (int i = 0; i < pingData.size(); i++) {
            PingSample ping = pingData.get(i);
            float x = padding + (i * xStep);
            if (!ping.isSuccess()) {
                canvas.drawCircle(x, padding + height, 5, failurePaint);
                continue;
            }
            if (ping.getDbConnectionMs() != null) {
                float y = padding + height - (Math.min(1f, ping.getDbConnectionMs() / maxLatency) * height);
                if (firstConn) {
                    pathDbConnection.moveTo(x, y);
                    firstConn = false;
                } else {
                    pathDbConnection.lineTo(x, y);
                }
                canvas.drawCircle(x, y, 4, lineDbConnectionPaint);
            }
            if (ping.getDbQueryMs() != null) {
                float y = padding + height - (Math.min(1f, ping.getDbQueryMs() / maxLatency) * height);
                if (firstQuery) {
                    pathDbQuery.moveTo(x, y);
                    firstQuery = false;
                } else {
                    pathDbQuery.lineTo(x, y);
                }
                canvas.drawCircle(x, y, 4, lineDbQueryPaint);
            }
        }
        canvas.drawPath(pathDbConnection, lineDbConnectionPaint);
        canvas.drawPath(pathDbQuery, lineDbQueryPaint);
    }
}
