pipeline {
    agent any

    tools {
        maven 'MAVEN_HOME'
        jdk 'JDK-17'
    }

    stages {

        stage('Checkout') {
            steps {
                echo "=== Récupération du projet depuis GitHub ==="
                git branch: 'hejer', url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build') {
            steps {
                echo "=== Compilation du projet ==="
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Tests') {
            steps {
                echo "=== Exécution des tests avec base H2 ==="
                // On suppose que tu as configuré un profil 'test' pour utiliser H2
                sh 'mvn test -Dspring.profiles.active=test'
            }
        }

        stage('Package') {
            steps {
                echo "=== Génération du fichier JAR ==="
                sh 'mvn package'
            }
        }

        stage('Finish') {
            steps {
                echo "Pipeline terminé avec succès à ${new Date()}"
            }
        }
    }
}
