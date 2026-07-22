package pe.com.hermes.appmobile.data.ping;

/** Una muestra de ping (latencia cliente + métricas BD del backend). */
public class PingSample {

    public final long timestampMs;
    public final Long latencyMs;
    public final Long dbConnectionMs;
    public final Long dbQueryMs;
    public final boolean success;
    public final String errorMessage;

    public PingSample(long timestampMs, Long latencyMs, Long dbConnectionMs, Long dbQueryMs,
                      boolean success, String errorMessage) {
        this.timestampMs = timestampMs;
        this.latencyMs = latencyMs;
        this.dbConnectionMs = dbConnectionMs;
        this.dbQueryMs = dbQueryMs;
        this.success = success;
        this.errorMessage = errorMessage;
    }

    public boolean isSuccess() {
        return success;
    }

    public Long getLatencyMs() {
        return latencyMs;
    }

    public Long getDbConnectionMs() {
        return dbConnectionMs;
    }

    public Long getDbQueryMs() {
        return dbQueryMs;
    }
}
