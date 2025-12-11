plugins {
    id("com.android.application")
    id("kotlin-android")
    // O Flutter Gradle Plugin deve ser aplicado após os plugins Android e Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Define o namespace da aplicação.
    namespace = "com.example.mobile_pi" 

    // O compileSdk e ndkVersion são definidos pelo Flutter.
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // Configurações de compatibilidade Java. Usando a versão 11, que é o padrão moderno do Flutter.
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    // Configurações Kotlin.
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ID da aplicação
        applicationId = "com.example.mobile_pi"
        
        // Versões do SDK definidas pelo Flutter.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        
        // Versões do app.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Configuração de assinatura para a release (usando a debug key por padrão se nenhuma for definida).
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Define a pasta de origem do código Flutter.
    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Não é necessário adicionar dependências aqui a menos que você esteja usando código nativo.
    // O Kotlin Stdlib é geralmente necessário.
    implementation(kotlin("stdlib"))
}