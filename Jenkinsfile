pipeline {
    agent any
    tools {
        maven 'M3_HOME'
        jdk 'JAVA_HOME'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'fares',
                    url: 'https://github.com/hajerKhazri/ProjetDevops.git'
                echo "✅ Code récupéré depuis GitHub"
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
                echo "✅ Build Maven réussi"
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
                echo "✅ Tests exécutés"
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo "✅ JAR généré dans target/"
            }
        }
    }

    post {
        success {
            echo '🎉 PIPELINE RÉUSSI ! Build + Test + Package'
        }
        failure {
            echo '❌ PIPELINE ÉCHOUÉ - Vérifie les logs'
        }
    }
}