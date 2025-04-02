FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy your built JAR file (adjust the name or use wildcard)
COPY target/*.jar app.jar

# Expose the default Spring Boot port
EXPOSE 8080

# Run the app
CMD ["java", "-jar", "app.jar"]
