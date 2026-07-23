package pe.com.hermes.appmobile.ui.menu;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.util.AttributeSet;
import android.view.View;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse.MovimientoDiaDto;

/** Gráfico lineal simple: ingresos (verde) vs salidas (rojo) por día. */
public class MovimientosLineChartView extends View {

    private final List<MovimientoDiaDto> points = new ArrayList<>();
    private final Paint gridPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint axisPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint ingresoPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint salidaPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint labelPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint legendPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Path pathIngreso = new Path();
    private final Path pathSalida = new Path();

    public MovimientosLineChartView(Context context) {
        super(context);
        init();
    }

    public MovimientosLineChartView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public MovimientosLineChartView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        gridPaint.setColor(Color.parseColor("#E2E8F0"));
        gridPaint.setStrokeWidth(1.5f);
        gridPaint.setStyle(Paint.Style.STROKE);

        axisPaint.setColor(Color.parseColor("#94A3B8"));
        axisPaint.setStrokeWidth(2f);

        ingresoPaint.setColor(Color.parseColor("#15803D"));
        ingresoPaint.setStrokeWidth(4f);
        ingresoPaint.setStyle(Paint.Style.STROKE);
        ingresoPaint.setStrokeJoin(Paint.Join.ROUND);
        ingresoPaint.setStrokeCap(Paint.Cap.ROUND);

        salidaPaint.setColor(Color.parseColor("#B91C1C"));
        salidaPaint.setStrokeWidth(4f);
        salidaPaint.setStyle(Paint.Style.STROKE);
        salidaPaint.setStrokeJoin(Paint.Join.ROUND);
        salidaPaint.setStrokeCap(Paint.Cap.ROUND);

        labelPaint.setColor(Color.parseColor("#64748B"));
        labelPaint.setTextSize(sp(10));
        labelPaint.setTextAlign(Paint.Align.CENTER);

        legendPaint.setColor(Color.parseColor("#334155"));
        legendPaint.setTextSize(sp(11));
        legendPaint.setTextAlign(Paint.Align.LEFT);
    }

    public void setData(List<MovimientoDiaDto> data) {
        points.clear();
        if (data != null) {
            points.addAll(data);
        }
        // Si no hay puntos, dibuja 7 días en cero para no dejar el área vacía
        if (points.isEmpty()) {
            for (int i = 0; i < 7; i++) {
                MovimientoDiaDto z = new MovimientoDiaDto();
                z.fecha = "";
                z.ingresos = 0;
                z.salidas = 0;
                points.add(z);
            }
        }
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        float w = getWidth();
        float h = getHeight();
        if (w <= 0 || h <= 0 || points.isEmpty()) {
            return;
        }

        float padL = dp(28);
        float padR = dp(10);
        float padT = dp(28);
        float padB = dp(28);
        float chartW = w - padL - padR;
        float chartH = h - padT - padB;

        long max = 1;
        for (MovimientoDiaDto p : points) {
            max = Math.max(max, Math.max(p.ingresos, p.salidas));
        }

        // Leyenda
        legendPaint.setColor(Color.parseColor("#15803D"));
        canvas.drawCircle(padL, dp(12), dp(4), legendPaint);
        legendPaint.setColor(Color.parseColor("#334155"));
        canvas.drawText("Ingresos", padL + dp(10), dp(16), legendPaint);
        legendPaint.setColor(Color.parseColor("#B91C1C"));
        canvas.drawCircle(padL + dp(90), dp(12), dp(4), legendPaint);
        legendPaint.setColor(Color.parseColor("#334155"));
        canvas.drawText("Salidas", padL + dp(100), dp(16), legendPaint);

        // Grid horizontal
        int lines = 4;
        for (int i = 0; i <= lines; i++) {
            float y = padT + chartH * i / lines;
            canvas.drawLine(padL, y, padL + chartW, y, gridPaint);
            long val = max - (max * i / lines);
            labelPaint.setTextAlign(Paint.Align.RIGHT);
            canvas.drawText(String.valueOf(val), padL - dp(4), y + dp(3), labelPaint);
        }

        // Ejes
        canvas.drawLine(padL, padT, padL, padT + chartH, axisPaint);
        canvas.drawLine(padL, padT + chartH, padL + chartW, padT + chartH, axisPaint);

        int n = points.size();
        pathIngreso.reset();
        pathSalida.reset();
        for (int i = 0; i < n; i++) {
            MovimientoDiaDto p = points.get(i);
            float x = padL + (n == 1 ? chartW / 2f : chartW * i / (n - 1f));
            float yIng = padT + chartH - (chartH * p.ingresos / (float) max);
            float ySal = padT + chartH - (chartH * p.salidas / (float) max);
            if (i == 0) {
                pathIngreso.moveTo(x, yIng);
                pathSalida.moveTo(x, ySal);
            } else {
                pathIngreso.lineTo(x, yIng);
                pathSalida.lineTo(x, ySal);
            }
            // Etiqueta cada ~3 puntos
            if (i == 0 || i == n - 1 || i % Math.max(1, n / 4) == 0) {
                labelPaint.setTextAlign(Paint.Align.CENTER);
                String label = shortDate(p.fecha);
                canvas.drawText(label, x, padT + chartH + dp(16), labelPaint);
            }
        }
        canvas.drawPath(pathIngreso, ingresoPaint);
        canvas.drawPath(pathSalida, salidaPaint);

        // Puntos
        Paint dotIng = new Paint(ingresoPaint);
        dotIng.setStyle(Paint.Style.FILL);
        Paint dotSal = new Paint(salidaPaint);
        dotSal.setStyle(Paint.Style.FILL);
        for (int i = 0; i < n; i++) {
            MovimientoDiaDto p = points.get(i);
            float x = padL + (n == 1 ? chartW / 2f : chartW * i / (n - 1f));
            float yIng = padT + chartH - (chartH * p.ingresos / (float) max);
            float ySal = padT + chartH - (chartH * p.salidas / (float) max);
            canvas.drawCircle(x, yIng, dp(3), dotIng);
            canvas.drawCircle(x, ySal, dp(3), dotSal);
        }
    }

    private String shortDate(String fecha) {
        if (fecha == null || fecha.length() < 10) return "—";
        // yyyy-MM-dd → dd/MM
        return fecha.substring(8, 10) + "/" + fecha.substring(5, 7);
    }

    private float dp(float v) {
        return v * getResources().getDisplayMetrics().density;
    }

    private float sp(float v) {
        return v * getResources().getDisplayMetrics().scaledDensity;
    }
}
