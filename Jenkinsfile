pipeline {
    agent any
    stages {
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
        stage('Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
                   steps {
                       echo 'Build Docker image'
                       sh 'docker build -t projet-devops:1.0 .'
                   }
               }

               stage('Run Docker Container') {
                   steps {
                       echo 'Run Docker container'
                       // On choisit un port libre pour éviter conflit
                       sh 'docker run -d -p 8082:8081 --name projet-devops-container projet-devops:1.0'
                   }
               }

}