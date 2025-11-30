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
               echo "=== Exécution des tests ==="
               sh 'mvn test -DskipTests' // skip les tests
           }
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
