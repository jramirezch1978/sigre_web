import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.devtools.ksp")
}

// Firma de release: credenciales en keystore.properties (raiz del proyecto, git-ignorado).
// Si el archivo no existe (ej. checkout limpio sin el keystore local), el release
// queda sin firmar en vez de fallar el build - solo `debug` sigue funcionando siempre.
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
        versionCode = 1
        versionName = "1.0.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // El default de la URL del API Gateway vive en assets/appconfig.json (ver AppConfig.kt),
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
    kotlinOptions {
        jvmTarget = "17"
    }
    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
}

dependencies {
    implementation(project(":common-ui"))

    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.recyclerview:recyclerview:1.3.2")
    implementation("androidx.swiperefreshlayout:swiperefreshlayout:1.1.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.4")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.8.4")
    implementation("androidx.activity:activity-ktx:1.9.1")

    // Networking — mismo patron que el modulo REST (api/rrhh) de FastSales: Retrofit + OkHttp.
    implementation("com.squareup.retrofit2:retrofit:2.11.0")
    implementation("com.squareup.retrofit2:converter-gson:2.11.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")

    // Sesion cifrada (reemplaza las SharedPreferences en claro que usaba FastSales).
    implementation("androidx.security:security-crypto:1.1.0-alpha06")

    // Cache offline (reemplaza el SQLiteOpenHelper manual de FastSales).
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    ksp("androidx.room:room-compiler:2.6.1")

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.2.1")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.6.1")
}
