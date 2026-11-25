
# Build Stage
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN for i in 1 2 3; do \
    mvn -B clean package -DskipTests && exit 0; \
    echo "Build failed. Retrying in 30 seconds..."; \
    sleep 30; \
    done; exit 1

# Run Stage
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
