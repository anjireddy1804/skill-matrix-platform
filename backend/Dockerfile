FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn --batch-mode clean package -DskipTests

FROM eclipse-temurin:21-jre-jammy AS runtime

RUN groupadd --system spring && useradd --system --gid spring spring
WORKDIR /app
COPY --from=build /build/target/skill-matrix-platform-1.0.0-SNAPSHOT.jar app.jar
RUN chown spring:spring /app/app.jar
USER spring:spring

EXPOSE 8080
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:+ExitOnOutOfMemoryError"
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar"]
