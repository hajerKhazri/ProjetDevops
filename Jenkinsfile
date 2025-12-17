# Créer un nouveau Jenkinsfile avec le contenu complet
@'
pipeline {
    agent any
    tools {
        maven "M3_HOME"
        jdk "JAVA_HOME"
    }
    stages {
        stage("Checkout") {
            steps {
                git branch: "fares",
                     url: "https://github.com/hajerKhazri/ProjetDevops.git"
            }
        }
        stage("Build") {
            steps {
                sh "mvn clean compile"
            }
        }
        stage("Test") {
            steps {
                sh "mvn test"
            }
            post {
                always {
                    junit "target/surefire-reports/*.xml"
                }
            }
        }
        stage("Package") {
            steps {
                sh "mvn package -DskipTests"
            }
        }
        stage("Docker Build") {
            steps {
                sh "docker build -t student-management:latest ."
            }
        }
    }
    post {
        success {
            echo "Pipeline réussi! 🎉"
        }
        failure {
            echo "Pipeline échoué! ❌"
        }
    }
}
'@ | Out-File -FilePath Jenkinsfile -Encoding UTF8