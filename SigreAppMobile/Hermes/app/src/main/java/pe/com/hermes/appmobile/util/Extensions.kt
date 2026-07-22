package pe.com.hermes.appmobile.util

import android.app.Activity
import android.widget.Toast
import pe.com.hermes.appmobile.SigreApplication

val Activity.app: SigreApplication
    get() = application as SigreApplication

fun Activity.toast(mensaje: String) {
    Toast.makeText(this, mensaje, Toast.LENGTH_LONG).show()
}
