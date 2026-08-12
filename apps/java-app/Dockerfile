# ---- Build stage ----
FROM maven:3.8.5-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ---- Runtime stage ----
FROM tomcat:9.0-jdk17-temurin
WORKDIR /usr/local/tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
