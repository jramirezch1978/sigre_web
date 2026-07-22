package pe.com.hermes.appmobile.util;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import pe.com.hermes.appmobile.data.config.ServerProfile;

/**
 * Prueba de conectividad TCP simple contra un servidor — equivalente moderno de
 * ValidarServerTask de FastSales (que hacia ping al webservice SOAP). No depende de
 * ningun endpoint HTTP concreto, solo abre/cierra un socket con timeout corto: sirve
 * tanto para validar un servidor recien tipeado (aun sin guardar) como el que ya esta
 * configurado como default, y para el badge de latencia en tiempo real del Login.
 */
public final class ConnectivityChecker {

    private static final int TIMEOUT_MS = 2500;

    private ConnectivityChecker() {
    }

    public static final class Resultado {
        public final boolean conectado;
        public final Long latenciaMs;

        public Resultado(boolean conectado, Long latenciaMs) {
            this.conectado = conectado;
            this.latenciaMs = latenciaMs;
        }
    }

    /** Bloqueante — llamar siempre desde un hilo de fondo (ver AsyncRunner). */
    public static Resultado probar(String hostIp, String port) {
        int puerto;
        try {
            puerto = Integer.parseInt(port);
        } catch (NumberFormatException e) {
            return new Resultado(false, null);
        }
        if (hostIp == null || hostIp.trim().isEmpty()) return new Resultado(false, null);

        long inicio = System.currentTimeMillis();
        try (Socket socket = new Socket()) {
            socket.connect(new InetSocketAddress(hostIp, puerto), TIMEOUT_MS);
            return new Resultado(true, System.currentTimeMillis() - inicio);
        } catch (IOException e) {
            return new Resultado(false, null);
        }
    }

    public static Resultado probar(ServerProfile server) {
        return probar(server.getHostIp(), server.getPort());
    }
}
