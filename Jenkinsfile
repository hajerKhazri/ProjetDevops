pipeline {
    agent any

    tools {
        maven 'M3'
        jdk 'JDK17'
    }

    environment {
        DOCKER_IMAGE = "emnakhelifi/student-management"
        DOCKER_TAG   = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'emna',
                    url: 'https://github.com/hajerKhazri/ProjetDevops.git'
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

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-id',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_TOKEN'
                    )
                ]) {
                    sh '''
                    echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USER" --password-stdin
                    docker push $DOCKER_IMAGE:$DOCKER_TAG
                    '''
                }
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                docker stop student-app || true
                docker rm student-app || true
                docker run -d \
                  -p 8089:8089 \
                  --name student-app \
                  $DOCKER_IMAGE:$DOCKER_TAG
                '''
            }
        }
    }

    post {
        success {
            echo ' Pipeline exécuté avec succès !'
        }
        failure {
            echo ' Échec du pipeline'
        }
    }
}
