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

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t student-management:latest .
                    docker images student-management
                '''
            }
        }

       stage('SonarQube Analysis') {
           steps {
               sh 'mvn sonar:sonar -Dsonar.projectKey=student-management -Dsonar.host.url=http://192.168.220.128:9000'
           }
       }
    }
}