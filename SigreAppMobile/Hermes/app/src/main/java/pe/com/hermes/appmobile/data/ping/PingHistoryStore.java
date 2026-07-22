package pe.com.hermes.appmobile.data.ping;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Historial en memoria de la sesión de Login — equivalente ligero a PingHistoryDbHelper
 * de FastSales (sin SQLite: basta para promedios de sesión y gráfica de últimos N).
 */
public class PingHistoryStore {

    private final List<PingSample> samples = new ArrayList<>();

    public synchronized void add(PingSample sample) {
        if (sample != null) {
            samples.add(sample);
        }
    }

    public synchronized void clear() {
        samples.clear();
    }

    public synchronized List<PingSample> getRecent(int limit) {
        if (samples.isEmpty()) {
            return Collections.emptyList();
        }
        if (limit <= 0 || limit >= samples.size()) {
            return new ArrayList<>(samples);
        }
        return new ArrayList<>(samples.subList(samples.size() - limit, samples.size()));
    }

    public synchronized int size() {
        return samples.size();
    }

    public synchronized double averageLatency() {
        return average(s -> s.latencyMs);
    }

    public synchronized double averageDbConnection() {
        return average(s -> s.dbConnectionMs);
    }

    public synchronized double averageDbQuery() {
        return average(s -> s.dbQueryMs);
    }

    public synchronized int successCount() {
        int n = 0;
        for (PingSample s : samples) {
            if (s.success) n++;
        }
        return n;
    }

    private double average(ValueExtractor extractor) {
        double sum = 0;
        int count = 0;
        for (PingSample s : samples) {
            if (!s.success) continue;
            Long v = extractor.get(s);
            if (v != null) {
                sum += v;
                count++;
            }
        }
        return count == 0 ? 0 : sum / count;
    }

    private interface ValueExtractor {
        Long get(PingSample s);
    }
}
