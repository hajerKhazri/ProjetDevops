pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'fares',
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

        stage('Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
    }

    post {
        always {
            echo 'Pipeline Student-Management completed!'
        }
    }
}