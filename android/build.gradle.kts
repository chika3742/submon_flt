allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    val builtInKotlinSupportedPlugins = listOf(
        ":firebase_analytics",
        ":firebase_app_check",
        ":cloud_functions",
        ":firebase_performance",
    )

    if (path in builtInKotlinSupportedPlugins) {
        apply(plugin = "com.android.built-in-kotlin")
    }
}

rootProject.layout.buildDirectory.set(rootProject.layout.projectDirectory.dir("../build"))
subprojects {
    project.layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(project.name))
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
