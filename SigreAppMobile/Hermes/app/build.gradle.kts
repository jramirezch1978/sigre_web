import java.util.Properties

plugins {
    id("com.android.application")
}

// ------------------------------------------------------------
// Versionado — mismo esquema que FastSales (version.properties):
//   VERSION_MAJOR.VERSION_MINOR.VERSION_PATCH  → versionName
//   VERSION_CODE                               → versionCode
// Tras assembleRelease / bundleRelease se incrementan CODE + MINOR.
// ------------------------------------------------------------
fun readVersionInfo(): Pair<Int, String> {
    val versionPropsFile = file("version.properties")
    val props = Properties()
    if (versionPropsFile.canRead()) {
        versionPropsFile.inputStream().use { props.load(it) }
    } else {
        props["VERSION_CODE"] = "1"
        props["VERSION_MAJOR"] = "1"
        props["VERSION_MINOR"] = "0"
        props["VERSION_PATCH"] = "0"
        versionPropsFile.writer().use { props.store(it, "Hermes version") }
    }
    val code = props.getProperty("VERSION_CODE", "1").toInt()
    val major = props.getProperty("VERSION_MAJOR", "1")
    val minor = props.getProperty("VERSION_MINOR", "0")
    val patch = props.getProperty("VERSION_PATCH", "0")
    return code to "$major.$minor.$patch"
}

fun incrementVersion() {
    val versionPropsFile = file("version.properties")
    val props = Properties()
    versionPropsFile.inputStream().use { props.load(it) }
    val code = props.getProperty("VERSION_CODE", "1").toInt() + 1
    val major = props.getProperty("VERSION_MAJOR", "1")
    val minor = props.getProperty("VERSION_MINOR", "0").toInt() + 1
    val patch = props.getProperty("VERSION_PATCH", "0")
    props["VERSION_CODE"] = code.toString()
    props["VERSION_MINOR"] = minor.toString()
    versionPropsFile.writer().use { props.store(it, null) }
    // FastSales: tras el build queda MAJOR.(MINOR+1).PATCH y CODE+1
    println("Version incrementada: $major.$minor.$patch (codigo: $code)")
}

val (appVersionCode, appVersionName) = readVersionInfo()

// Firma de release: credenciales en keystore.properties (raiz del proyecto, git-ignorado).
val keystorePropertiesFile = rootProject.file("keystore.properties")
val keystoreProperties = Properties()
val tieneFirmaRelease = keystorePropertiesFile.exists()
if (tieneFirmaRelease) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "pe.com.hermes.appmobile"
    compileSdk = 35

    defaultConfig {
        applicationId = "pe.com.hermes.appmobile"
        // 26+ (Android 8.0) requerido por el icono adaptativo (mipmap-anydpi-v26).
        minSdk = 26
        targetSdk = 35
        versionCode = appVersionCode
        versionName = appVersionName

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // El default de la URL del API Gateway vive en assets/appconfig.json (ver AppConfig.java),
        // no aquí — es un archivo real dentro de la app, editable en runtime desde Login.
    }

    signingConfigs {
        if (tieneFirmaRelease) {
            create("release") {
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            if (tieneFirmaRelease) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
}

dependencies {
    implementation(project(":common-ui"))

    implementation("androidx.core:core:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.recyclerview:recyclerview:1.3.2")
    implementation("androidx.swiperefreshlayout:swiperefreshlayout:1.1.0")
    implementation("androidx.activity:activity:1.9.1")

    // Networking — mismo patron que el modulo REST (api/rrhh) de FastSales: Retrofit + OkHttp,
    // en modo asincrono clasico (Call.enqueue), sin coroutines.
    implementation("com.squareup.retrofit2:retrofit:2.11.0")
    implementation("com.squareup.retrofit2:converter-gson:2.11.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    // Sesion cifrada (reemplaza las SharedPreferences en claro que usaba FastSales).
    implementation("androidx.security:security-crypto:1.1.0-alpha06")

    // Google Play In-App Updates (mismo enfoque que FastSales).
    implementation("com.google.android.play:app-update:2.1.0")

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
}

tasks.register("incrementVersionTask") {
    group = "versioning"
    description = "Incrementa VERSION_CODE y VERSION_MINOR (esquema FastSales)"
    doLast { incrementVersion() }
}

// Mismo enganche que FastSales (tasks.whenTaskAdded): el whenReady anterior NO
// ejecutaba incrementVersionTask (no aparecía en el grafo) y la app quedaba en 1.0.0.
tasks.whenTaskAdded {
    if (name == "assembleRelease") {
        finalizedBy("incrementVersionTask")
    }
    if (name == "bundleRelease") {
        // Si también hay assembleRelease, solo incrementa una vez (tras el APK).
        if (!gradle.taskGraph.hasTask(":app:assembleRelease")
                && !gradle.taskGraph.hasTask("assembleRelease")) {
            finalizedBy("incrementVersionTask")
        }
    }
}
