# Build stage with Java 24
FROM eclipse-temurin:24-jdk-ubi10-minimal AS build
WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

# Run stage with Java 24 JRE
FROM eclipse-temurin:24-jre-ubi10-minimal
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]