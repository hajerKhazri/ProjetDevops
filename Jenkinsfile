pipeline {
    agent any

    tools {
        maven 'M3_HOME'  // Doit correspondre au nom configuré dans Jenkins
        jdk 'JAVA_HOME'   // Doit correspondre au nom configuré dans Jenkins
    }

    stages {
        // Étape 1 : Récupération du code
        stage('Checkout') {
            steps {
                git branch: 'fares',
                    url: 'https://github.com/hajerKhazri/ProjetDevops.git'
                echo "Code récupéré depuis la branche 'fares'"
            }
        }

        // Étape 2 : Compilation
        stage('Build') {
            steps {
                sh 'mvn clean compile'
                echo "Build réussi"
            }
        }

        // Étape 3 : Tests
        stage('Test') {
            steps {
                sh 'mvn test'
                echo "Tests exécutés"
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        // Étape 4 : Packaging
        stage('Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo "JAR généré"
            }
        }

        // Étape 5 : Déploiement (exemple)
        stage('Deploy') {
            steps {
                echo "Déploiement en cours..."
                // Ajoute ici tes commandes de déploiement
            }
        }
    }

    post {
        success {
            echo 'Pipeline réussi! 🎉'
        }
        failure {
            echo 'Pipeline échoué! ❌'
        }
    }
}