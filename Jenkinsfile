pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'fares', url: 'https://github.com/hajerKhazri/ProjetDevops.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test -Dtest=!TestSpringBoot'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    sh '''
                        docker build -t fares/student-management:latest .
                        docker tag student-management:latest fares/student-management:latest
                    '''
                }
            }
        }

        stage('SonarQube') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=student-management -Dsonar.token=$SONAR_TOKEN'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/mysql-deployment.yaml -n devops
                    kubectl apply -f k8s/spring-deployment.yaml -n devops
                '''
            }
        }
    }
    post {
        always {
            echo '🎉 PIPELINE DEVOPS 6/6 TERMINÉE! 🎉'
            echo '✅ Checkout → Build → Test → Package → Docker → SonarQube → Deploy'
        }
        success {
            sh '''
                echo "✅ Application deployed to Kubernetes!"
                echo "📦 Check pods: kubectl get pods -n devops"
                echo "🌐 Access app: minikube service spring-service -n devops --url"
            '''
        }
    }
}