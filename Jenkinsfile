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

        stage('5. Docker Build') {
            steps {
                script {
                    sh 'docker build -t student-management:latest .'
                    sh 'docker images | grep student-management'
                    echo '✅ Image Docker créée : student-management:latest'
                }
            }
        }

        // NOUVELLE ÉTAPE : Docker Push vers Docker Hub
        stage('6. Docker Push to Hub') {
            steps {
                script {
                    echo '🚀 Pushing to Docker Hub...'

                    // 1. Tagger avec ton username Docker Hub
                    sh 'docker tag student-management:latest faresbelga/student-management:latest'

                    // 2. Se connecter à Docker Hub avec TES CREDENTIALS
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                            echo "Connexion à Docker Hub..."
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        '''
                    }

                    // 3. Pousser l'image
                    sh 'docker push faresbelga/student-management:latest'

                    // 4. Vérifier
                    sh 'docker images | grep faresbelga'

                    echo '✅ Image poussée sur Docker Hub: faresbelga/student-management:latest'
                    echo '📎 Lien: https://hub.docker.com/r/faresbelga/student-management'
                }
            }
        }
    }

    post {
        success {
            echo '🎉 PIPELINE COMPLET RÉUSSI ! (Build + Test + Package + Docker Build + Docker Push)'
            echo '📦 JAR: target/student-management-0.0.1-SNAPSHOT.jar'
            echo '🐳 Image Docker: faresbelga/student-management:latest'
        }
        failure {
            echo '❌ PIPELINE ÉCHOUÉ - Vérifie les logs'
        }
    }
}