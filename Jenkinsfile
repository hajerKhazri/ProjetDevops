pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

    environment {
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_PROJECT_KEY = 'projet-devops'
        DOCKER_IMAGE = 'projet-devops:1.0'
    }

    stages {

        stage('Checkout GitHub') {
            steps {
                git branch: 'hejer',
                    url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh """
                    mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.branch.name=hejer
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                docker rm -f projet-devops-container || true
                docker run -d -p 8082:8081 --name projet-devops-container $DOCKER_IMAGE
                '''
            }
        }
    }
}
