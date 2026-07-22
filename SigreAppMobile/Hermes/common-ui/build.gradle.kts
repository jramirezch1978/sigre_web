plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

// Libreria reutilizable de componentes UI/util, portados y modernizados desde
// FastSales (dialogos de confirmacion/mensaje, validacion de forms, edge-to-edge,
// deteccion de hardware PDA, logging) para que cualquier app SIGRE (Hermes u
// otras futuras) los reutilice sin duplicar el patron en cada pantalla.
android {
    namespace = "pe.com.hermes.common"
    compileSdk = 35

    defaultConfig {
        minSdk = 26
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
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.activity:activity-ktx:1.9.1")
    implementation("com.google.android.material:material:1.12.0")
}
