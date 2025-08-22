allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// 👇 اضافه کردن تنظیم JVM Toolchain برای همه زیرپروژه‌ها
plugins.withId("org.jetbrains.kotlin.android") {
    the<org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension>().apply {
        jvmToolchain(21) // چون JDK شما 21 هست
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
