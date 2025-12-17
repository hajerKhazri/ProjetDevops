pipeline {
    agent any

    tools {
        // Mettre ici le nom exact de ton installation Maven dans Jenkins
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        // Variables d'environnement si besoin
        DOCKER_IMAGE = 'projetdevops:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'hejer', url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build Maven') {
            steps {
                // Compilation et tests
                sh 'mvn clean package -DskipTests=false'
            }
        }

        stage('Docker Build') {
            steps {
                // Construire l'image Docker
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Run') {
            steps {
                // Lancer le conteneur pour test
                sh "docker run --rm -p 8080:8080 ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        success {
            echo 'Build terminé avec succès !'
        }
        failure {
            echo 'Le build a échoué ! Vérifie les erreurs.'
        }
    }
}
