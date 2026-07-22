package pe.com.hermes.appmobile.data.device;

import android.content.Context;
import android.os.Build;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;

/** Arma el payload de registro con datos del equipo + red (llamar fuera del UI thread). */
public final class DeviceRegistrationFactory {

    private DeviceRegistrationFactory() {}

    public static RegistrarDispositivoRequest crear(Context context) {
        DeviceRegistry registry = new DeviceRegistry(context);
        DeviceNetworkInfo net = DeviceNetworkInfo.recolectar(context);
        RegistrarDispositivoRequest req = new RegistrarDispositivoRequest(
                registry.obtenerDeviceId(context),
                Build.MANUFACTURER,
                Build.MODEL,
                Build.MANUFACTURER + " " + Build.MODEL,
                "Android " + Build.VERSION.RELEASE);
        req.imei = net.imei;
        req.ipPrivada = net.ipPrivada;
        req.ipPublica = net.ipPublica;
        return req;
    }
}
