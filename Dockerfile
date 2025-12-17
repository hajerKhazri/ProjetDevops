# IMAGE DE BASE : OpenJDK 17 (version complète)
FROM openjdk:17-jdk

# 1. CRÉER UN RÉPERTOIRE DE TRAVAIL
WORKDIR /app

# 2. COPIER LE JAR GÉNÉRÉ PAR MAVEN
# Assure-toi que le JAR est bien dans target/ après l'étape Package
COPY target/student-management-0.0.1-SNAPSHOT.jar app.jar

# 3. EXPOSER LE PORT DE L'APPLICATION SPRING BOOT
EXPOSE 8080

# 4. COMMANDE POUR DÉMARRER L'APPLICATION
ENTRYPOINT ["java", "-jar", "app.jar"]

# Optionnel : Ajouter des variables d'environnement
# ENV SPRING_PROFILES_ACTIVE=prod
# ENV JAVA_OPTS="-Xmx512m -Xms256m"