pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        DOCKER_IMAGE = 'projetdevops:latest'
        SONARQUBE = 'SonarQube' // Nom de ton installation SonarQube dans Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'hejer', url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests=false'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool name: "${SONARQUBE}", type: 'hudson.plugins.sonar.SonarRunnerInstallation'
            }
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh "mvn sonar:sonar -Dsonar.projectKey=student-management -Dsonar.host.url=http://localhost:9000 -Dsonar.login=<TON_TOKEN>"
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Docker Run') {
            steps {
                sh 'docker run --rm -p 8081:8080 projetdevops:latest'

            }
        }
    }

    post {
        success { echo 'Pipeline terminé avec succès !' }
        failure { echo 'Le pipeline a échoué ! Vérifie les logs.' }
    }
}
