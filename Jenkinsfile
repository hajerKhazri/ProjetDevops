pipeline {
    agent any

    tools {
       maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }

    stages {
        stage('1. Checkout Git') {
            steps {
                echo '📦 Code récupéré depuis GitHub'
            }
        }

        stage('2. Build Maven') {
            steps {
                sh 'mvn clean compile'
                echo '✅ Build réussi'
            }
        }

        stage('3. Tests') {
            steps {
                sh 'mvn test'
                echo '✅ Tests exécutés'
            }
        }

        stage('4. Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo '✅ JAR créé'
            }
        }
    }

    post {
        success {
            echo '🎉 PIPELINE RÉUSSI via SCM Git !'
        }
    }
}