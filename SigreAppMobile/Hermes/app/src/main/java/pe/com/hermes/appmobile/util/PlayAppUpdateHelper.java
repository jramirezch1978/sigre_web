package pe.com.hermes.appmobile.util;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.util.Log;
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
import pe.com.hermes.appmobile.R;

/**
 * Comprueba actualizaciones en Google Play al abrir el login (igual que FastSales).
 * <ul>
 *   <li>1–3 revisiones (versionCode) atrás → aviso opcional (flexible).</li>
 *   <li>{@link #FORCE_BEHIND_THRESHOLD}+ revisiones atrás → actualización obligatoria (inmediata).</li>
 * </ul>
 * Solo aplica si la app fue instalada desde Play; si no hay info, deja continuar.
 */
public final class PlayAppUpdateHelper {

    private static final String TAG = "PlayAppUpdate";

    /** Diferencia de versionCode a partir de la cual la actualización es obligatoria. */
    public static final int FORCE_BEHIND_THRESHOLD = 4;

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
                        Log.i(TAG, "No se pudo consultar Play Update (¿sideload/emulador?): "
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
            if (!forceMode) {
                finishContinue();
            }
            return;
        }
        if (forceMode) {
            new AlertDialog.Builder(activity)
                    .setTitle(R.string.update_obligatoria_titulo)
                    .setMessage(R.string.update_obligatoria_rechazada)
                    .setCancelable(false)
                    .setPositiveButton(R.string.update_actualizar, (dialog, which) -> {
                        openPlayStore();
                        activity.finish();
                    })
                    .setNegativeButton(R.string.update_salir, (dialog, which) -> activity.finish())
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
        Log.i(TAG, "Update disponible. Actual=" + current + " Play=" + available
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
        String msg = activity.getString(R.string.update_opcional_mensaje, available, behind);
        new AlertDialog.Builder(activity)
                .setTitle(R.string.update_opcional_titulo)
                .setMessage(msg)
                .setCancelable(true)
                .setPositiveButton(R.string.update_actualizar, (dialog, which) -> startFlexible(info))
                .setNegativeButton(R.string.update_mas_tarde, (dialog, which) -> finishContinue())
                .show();
    }

    private void showForceDialog(final AppUpdateInfo info, int behind, int available) {
        String msg = activity.getString(R.string.update_obligatoria_mensaje, behind, available);
        new AlertDialog.Builder(activity)
                .setTitle(R.string.update_obligatoria_titulo)
                .setMessage(msg)
                .setCancelable(false)
                .setPositiveButton(R.string.update_ahora, (dialog, which) -> {
                    if (info.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                        startImmediate(info);
                    } else if (info.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)) {
                        startFlexible(info);
                    } else {
                        openPlayStore();
                        activity.finish();
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
            Log.e(TAG, "Error iniciando update inmediata", e);
            openPlayStore();
            activity.finish();
        } catch (Exception e) {
            Log.e(TAG, "Error iniciando update inmediata", e);
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
            finishContinue();
        } catch (IntentSender.SendIntentException e) {
            Log.e(TAG, "Error iniciando update flexible", e);
            openPlayStore();
            finishContinue();
        } catch (Exception e) {
            Log.e(TAG, "Error iniciando update flexible", e);
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
                    Toast.makeText(activity, R.string.update_descarga_fallida, Toast.LENGTH_LONG).show();
                }
            }
        };
        updateManager.registerListener(flexibleListener);
    }

    private void promptCompleteFlexible() {
        new AlertDialog.Builder(activity)
                .setTitle(R.string.update_lista_titulo)
                .setMessage(R.string.update_lista_mensaje)
                .setCancelable(false)
                .setPositiveButton(R.string.update_instalar, (dialog, which) -> updateManager.completeUpdate())
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
            return (int) pi.getLongVersionCode();
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
