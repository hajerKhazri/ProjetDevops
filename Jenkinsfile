pipeline {
    agent any

   tools {
       maven 'M3'
       jdk 'JDK17'
   }

    stages {
        stage('Checkout') {
            steps {
                // Pull the code from Git
                git branch: 'emna', url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

         stage('SonarQube Analysis') {
                    steps {
                        withSonarQubeEnv('MySonarServer') {
                            sh 'mvn clean verify sonar:sonar'
                        }
                    }
                }

        stage('Archive .jar') {
            steps {
                // Archive the generated jar
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t emna/student-management:latest .'
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                docker stop student-app || true
                docker rm student-app || true
                docker run -d -p 8089:8089 --name student-app emna/student-management:latest
                '''
            }
        }



    }

    post {
        success {
            echo 'Pipeline finished successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
