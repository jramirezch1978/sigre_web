package pe.com.sytco.fastsales.util;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.play.core.appupdate.AppUpdateInfo;
import com.google.android.play.core.appupdate.AppUpdateManager;
import com.google.android.play.core.appupdate.AppUpdateManagerFactory;
import com.google.android.play.core.appupdate.AppUpdateOptions;
import com.google.android.play.core.install.InstallState;
import com.google.android.play.core.install.InstallStateUpdatedListener;
import com.google.android.play.core.install.model.AppUpdateType;
import com.google.android.play.core.install.model.InstallStatus;
import com.google.android.play.core.install.model.UpdateAvailability;

/**
 * Comprueba actualizaciones en Google Play al abrir la app (antes del login).
 * <ul>
 *   <li>1 versión atrás → aviso opcional (flexible: descarga e instala).</li>
 *   <li>{@link #FORCE_BEHIND_THRESHOLD}+ versiones atrás → actualización obligatoria (inmediata).</li>
 * </ul>
 * Solo aplica si la app fue instalada desde Play; si no hay info, deja continuar.
 */
public final class PlayAppUpdateHelper {

    /** Diferencia de versionCode a partir de la cual la actualización es obligatoria. */
    public static final int FORCE_BEHIND_THRESHOLD = 2;

    public static final int REQUEST_UPDATE = 44001;

    public interface Callback {
        /** Se puede usar la app (login, etc.). */
        void onContinue();
    }

    private final Activity activity;
    private final AppUpdateManager updateManager;
    private final Callback callback;
    private InstallStateUpdatedListener flexibleListener;
    private boolean forceMode;
    private boolean finished;

    public PlayAppUpdateHelper(@NonNull Activity activity, @NonNull Callback callback) {
        this.activity = activity;
        this.callback = callback;
        this.updateManager = AppUpdateManagerFactory.create(activity);
    }

    public void checkOnStartup() {
        updateManager.getAppUpdateInfo()
                .addOnSuccessListener(new OnSuccessListener<AppUpdateInfo>() {
                    @Override
                    public void onSuccess(AppUpdateInfo info) {
                        handleInfo(info);
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        LogHelper.i("PlayAppUpdate",
                                "No se pudo consultar Play Update (¿sideload/emulador?): "
                                        + e.getMessage());
                        finishContinue();
                    }
                });
    }

    /** Reanuda actualización inmediata incompleta (p. ej. tras rotar o volver a la app). */
    public void resumeIfNeeded() {
        updateManager.getAppUpdateInfo()
                .addOnSuccessListener(new OnSuccessListener<AppUpdateInfo>() {
                    @Override
                    public void onSuccess(AppUpdateInfo info) {
                        if (info.updateAvailability()
                                == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
                            startImmediate(info);
                        } else if (info.installStatus() == InstallStatus.DOWNLOADED) {
                            promptCompleteFlexible();
                        }
                    }
                });
    }

    public void onActivityResult(int requestCode, int resultCode) {
        if (requestCode != REQUEST_UPDATE) {
            return;
        }
        if (resultCode == Activity.RESULT_OK) {
            // En inmediato la app suele reiniciarse; en flexible continuar.
            if (!forceMode) {
                finishContinue();
            }
            return;
        }
        if (forceMode) {
            new AlertDialog.Builder(activity)
                    .setTitle("Actualización obligatoria")
                    .setMessage("Debe actualizar la aplicación desde Google Play para continuar.")
                    .setCancelable(false)
                    .setPositiveButton("Actualizar", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            openPlayStore();
                            activity.finish();
                        }
                    })
                    .setNegativeButton("Salir", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            activity.finish();
                        }
                    })
                    .show();
        } else {
            finishContinue();
        }
    }

    public void unregister() {
        if (flexibleListener != null) {
            updateManager.unregisterListener(flexibleListener);
            flexibleListener = null;
        }
    }

    private void handleInfo(AppUpdateInfo info) {
        if (info.updateAvailability()
                == UpdateAvailability.DEVELOPER_TRIGGERED_UPDATE_IN_PROGRESS) {
            startImmediate(info);
            return;
        }
        if (info.installStatus() == InstallStatus.DOWNLOADED) {
            promptCompleteFlexible();
            return;
        }
        if (info.updateAvailability() != UpdateAvailability.UPDATE_AVAILABLE) {
            finishContinue();
            return;
        }

        int current = currentVersionCode();
        int available = info.availableVersionCode();
        int behind = available - current;
        LogHelper.i("PlayAppUpdate",
                "Update disponible. Actual=" + current + " Play=" + available
                        + " atrasada=" + behind);

        if (behind <= 0) {
            finishContinue();
            return;
        }

        forceMode = behind >= FORCE_BEHIND_THRESHOLD;
        if (forceMode) {
            showForceDialog(info, behind, available);
        } else {
            showOptionalDialog(info, behind, available);
        }
    }

    private void showOptionalDialog(final AppUpdateInfo info, int behind, int available) {
        new AlertDialog.Builder(activity)
                .setTitle("Nueva versión disponible")
                .setMessage("Hay una versión más reciente en Google Play"
                        + " (código " + available + ").\n\n"
                        + "Su app está " + behind + " versión(es) atrás.\n"
                        + "¿Desea actualizar ahora? Se descargará e instalará desde Play.")
                .setCancelable(true)
                .setPositiveButton("Actualizar", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        startFlexible(info);
                    }
                })
                .setNegativeButton("Más tarde", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        finishContinue();
                    }
                })
                .show();
    }

    private void showForceDialog(final AppUpdateInfo info, int behind, int available) {
        new AlertDialog.Builder(activity)
                .setTitle("Actualización obligatoria")
                .setMessage("Su aplicación está desactualizada ("
                        + behind + " versiones atrás respecto a Google Play).\n\n"
                        + "Debe actualizar a la versión " + available
                        + " para continuar. Se descargará e instalará ahora.")
                .setCancelable(false)
                .setPositiveButton("Actualizar ahora", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        if (info.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                            startImmediate(info);
                        } else if (info.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)) {
                            startFlexible(info);
                        } else {
                            openPlayStore();
                            activity.finish();
                        }
                    }
                })
                .show();
    }

    private void startImmediate(AppUpdateInfo info) {
        forceMode = true;
        try {
            updateManager.startUpdateFlowForResult(
                    info,
                    activity,
                    AppUpdateOptions.newBuilder(AppUpdateType.IMMEDIATE).build(),
                    REQUEST_UPDATE);
        } catch (IntentSender.SendIntentException e) {
            LogHelper.e("PlayAppUpdate", "Error iniciando update inmediata", e);
            openPlayStore();
            activity.finish();
        } catch (Exception e) {
            LogHelper.e("PlayAppUpdate", "Error iniciando update inmediata", e);
            openPlayStore();
            activity.finish();
        }
    }

    private void startFlexible(AppUpdateInfo info) {
        if (!info.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)) {
            if (info.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                startImmediate(info);
                return;
            }
            openPlayStore();
            finishContinue();
            return;
        }
        registerFlexibleListener();
        try {
            updateManager.startUpdateFlowForResult(
                    info,
                    activity,
                    AppUpdateOptions.newBuilder(AppUpdateType.FLEXIBLE).build(),
                    REQUEST_UPDATE);
            // El usuario puede seguir usando la app mientras descarga.
            finishContinue();
        } catch (IntentSender.SendIntentException e) {
            LogHelper.e("PlayAppUpdate", "Error iniciando update flexible", e);
            openPlayStore();
            finishContinue();
        } catch (Exception e) {
            LogHelper.e("PlayAppUpdate", "Error iniciando update flexible", e);
            openPlayStore();
            finishContinue();
        }
    }

    private void registerFlexibleListener() {
        if (flexibleListener != null) {
            return;
        }
        flexibleListener = new InstallStateUpdatedListener() {
            @Override
            public void onStateUpdate(@NonNull InstallState state) {
                if (state.installStatus() == InstallStatus.DOWNLOADED) {
                    promptCompleteFlexible();
                } else if (state.installStatus() == InstallStatus.FAILED) {
                    Toast.makeText(activity,
                            "No se pudo descargar la actualización. Intente desde Play Store.",
                            Toast.LENGTH_LONG).show();
                }
            }
        };
        updateManager.registerListener(flexibleListener);
    }

    private void promptCompleteFlexible() {
        new AlertDialog.Builder(activity)
                .setTitle("Actualización lista")
                .setMessage("La nueva versión se descargó. Pulse Instalar para aplicarla.")
                .setCancelable(false)
                .setPositiveButton("Instalar", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        updateManager.completeUpdate();
                    }
                })
                .show();
    }

    private void openPlayStore() {
        String pkg = activity.getPackageName();
        try {
            activity.startActivity(new Intent(Intent.ACTION_VIEW,
                    Uri.parse("market://details?id=" + pkg)));
        } catch (Exception ex) {
            activity.startActivity(new Intent(Intent.ACTION_VIEW,
                    Uri.parse("https://play.google.com/store/apps/details?id=" + pkg)));
        }
    }

    private int currentVersionCode() {
        try {
            PackageInfo pi = activity.getPackageManager()
                    .getPackageInfo(activity.getPackageName(), 0);
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
                return (int) pi.getLongVersionCode();
            }
            return pi.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            return 0;
        }
    }

    private void finishContinue() {
        if (finished) {
            return;
        }
        finished = true;
        callback.onContinue();
    }
}
