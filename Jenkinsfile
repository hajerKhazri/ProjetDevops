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

        // ÉTAPE DOCKER AJOUTÉE ICI
        stage('5. Docker Build') {
            steps {
                script {
                    // 1. Construire l'image Docker
                    sh 'docker build -t student-management:latest .'

                    // 2. Vérifier que l'image a été créée
                    sh 'docker images | grep student-management'

                    // 3. Optionnel : Tagger pour Docker Hub
                    // sh 'docker tag student-management:latest tonusername/student-management:latest'

                    echo '✅ Image Docker créée : student-management:latest'
                }
            }
        }

        // ÉTAPE FUTURE : Docker Push (vers Docker Hub)
        stage('6. Docker Push') {
            steps {
                echo '🚧 Étape Docker Push - à configurer plus tard'
                // sh 'docker push tonusername/student-management:latest'
                // echo '✅ Image poussée sur Docker Hub'
            }
        }
    }

    post {
        success {
            echo '🎉 PIPELINE COMPLET RÉUSSI ! (Build + Test + Package + Docker)'
            echo 'Image Docker disponible : student-management:latest'
        }
        failure {
            echo '❌ PIPELINE ÉCHOUÉ - Vérifie les logs'
        }
    }
}