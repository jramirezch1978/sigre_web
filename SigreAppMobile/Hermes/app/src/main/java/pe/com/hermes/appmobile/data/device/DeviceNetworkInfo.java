package pe.com.hermes.appmobile.data.device;

import android.content.Context;
import android.net.wifi.WifiManager;
import android.telephony.TelephonyManager;
import android.text.format.Formatter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Enumeration;
import java.util.regex.Pattern;

/**
 * Recolecta IP privada/pública (solo IPv4) e IMEI.
 * Debe ejecutarse fuera del hilo UI (usa red).
 */
public final class DeviceNetworkInfo {

    private static final int TIMEOUT_MS = 4_000;
    /** IPv4: 0.0.0.0 … 255.255.255.255 (máx. 15 caracteres). */
    private static final Pattern IPV4 = Pattern.compile(
            "^(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$");

    public final String ipPrivada;
    public final String ipPublica;
    public final String imei;

    private DeviceNetworkInfo(String ipPrivada, String ipPublica, String imei) {
        this.ipPrivada = ipPrivada;
        this.ipPublica = ipPublica;
        this.imei = imei;
    }

    public static DeviceNetworkInfo recolectar(Context context) {
        Context app = context.getApplicationContext();
        String privada = obtenerIpPrivada(app);
        String publica = obtenerIpPublica();
        String imei = obtenerImei(app);
        return new DeviceNetworkInfo(privada, publica, imei);
    }

    private static String obtenerIpPrivada(Context context) {
        String fromInterfaces = ipDesdeInterfaces();
        if (fromInterfaces != null) {
            return fromInterfaces;
        }
        return soloIpv4(ipDesdeWifi(context));
    }

    private static String ipDesdeInterfaces() {
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            if (interfaces == null) {
                return null;
            }
            for (NetworkInterface nif : Collections.list(interfaces)) {
                if (!nif.isUp() || nif.isLoopback()) {
                    continue;
                }
                for (InetAddress address : Collections.list(nif.getInetAddresses())) {
                    if (!(address instanceof Inet4Address)) {
                        continue;
                    }
                    if (address.isLoopbackAddress() || address.isLinkLocalAddress()) {
                        continue;
                    }
                    return soloIpv4(address.getHostAddress());
                }
            }
        } catch (Exception ignored) {
            // Se intenta fallback WiFi.
        }
        return null;
    }

    @SuppressWarnings("deprecation")
    private static String ipDesdeWifi(Context context) {
        try {
            WifiManager wifi = (WifiManager) context.getApplicationContext()
                    .getSystemService(Context.WIFI_SERVICE);
            if (wifi == null || wifi.getConnectionInfo() == null) {
                return null;
            }
            int ip = wifi.getConnectionInfo().getIpAddress();
            if (ip == 0) {
                return null;
            }
            return Formatter.formatIpAddress(ip);
        } catch (Exception ignored) {
            return null;
        }
    }

    /** api4.ipify.org responde siempre IPv4. */
    private static String obtenerIpPublica() {
        HttpURLConnection conn = null;
        try {
            URL url = new URL("https://api4.ipify.org");
            conn = (HttpURLConnection) url.openConnection();
            conn.setConnectTimeout(TIMEOUT_MS);
            conn.setReadTimeout(TIMEOUT_MS);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "text/plain");
            int code = conn.getResponseCode();
            if (code < 200 || code >= 300) {
                return null;
            }
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line = reader.readLine();
                return soloIpv4(line);
            }
        } catch (Exception ignored) {
            return null;
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private static String soloIpv4(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String ip = value.trim();
        if (ip.contains(":") || ip.length() > 15 || !IPV4.matcher(ip).matches()) {
            return null;
        }
        return ip;
    }

    @SuppressWarnings("deprecation")
    private static String obtenerImei(Context context) {
        try {
            TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
            if (tm == null) {
                return null;
            }
            String imei = tm.getImei();
            if (imei == null || imei.isBlank()) {
                imei = tm.getDeviceId();
            }
            return (imei == null || imei.isBlank()) ? null : imei.trim();
        } catch (Exception ignored) {
            return null;
        }
    }
}
