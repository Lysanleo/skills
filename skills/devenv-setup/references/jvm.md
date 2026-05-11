# JVM Reference

Detect via: `pom.xml`, `build.gradle`, `build.gradle.kts`, `gradlew`, `mvnw`, `settings.gradle`.

## Common Setup

- Prefer checked-in wrapper: `./gradlew` or `./mvnw`.
- Add JDK version matching repo config.
- Add extra tools only if repo uses them directly.

## Validation

- Gradle: `devenv shell ./gradlew test`
- Maven: `devenv shell ./mvnw test`
