pipeline {
    agent any

    tools {
        maven 'Maven-3.9.6'
        jdk 'JDK-17'
    }

    environment {
        // Variables pour Docker Hub (à configurer dans Jenkins Credentials)
        DOCKER_REGISTRY = 'faresbelga'
        DOCKER_IMAGE = 'student-management'
        DOCKER_TAG = 'latest'

        // Variable SonarQube (optionnel)
        SONAR_HOST_URL = 'http://localhost:9000'
    }

    stages {
        // Étape 1: Récupération du code
        stage('1. Checkout Git') {
            steps {
                checkout scm
                echo '📦 Code récupéré depuis GitHub'
            }
        }

        // Étape 2: Build Maven
        stage('2. Build Maven') {
            steps {
                sh 'mvn clean compile'
                echo '✅ Build réussi'
            }
        }

        // Étape 3: Tests
        stage('3. Tests') {
            steps {
                sh 'mvn test'
                echo '✅ Tests exécutés'
            }
        }

        // Étape 4: Package JAR
        stage('4. Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo '✅ JAR créé'
            }
        }

        // Étape 5: Analyse SonarQube
        stage('5. Analyse SonarQube') {
            steps {
                script {
                    // Utilise la configuration SonarQube définie dans Jenkins
                    withSonarQubeEnv('SonarQube-Local') {
                        sh '''
                        mvn clean verify sonar:sonar \
                          -Dsonar.projectKey=student-management \
                          -Dsonar.projectName="Student Management" \
                          -Dsonar.java.binaries=target/classes \
                          -Dsonar.sources=src/main/java \
                          -Dsonar.tests=src/test/java \
                          -Dsonar.java.source=17
                        '''
                    }
                }
            }
        }

        // Étape 6: Quality Gate
        stage('6. Quality Gate') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate()

                        echo "🔍 Résultats Quality Gate:"
                        echo "  - Status: ${qg.status}"
                        echo "  - Conditions:"

                        qg.conditions.each { condition ->
                            echo "    • ${condition.metricKey}: ${condition.status} (${condition.actualValue})"
                        }

                        if (qg.status != 'OK') {
                            // Tu peux choisir de fail ou warning
                            error "❌ Quality Gate échouée: ${qg.status}"

                            // OU pour warning seulement:
                            // currentBuild.result = 'UNSTABLE'
                            // echo "⚠️ Build unstable à cause de Quality Gate"
                        } else {
                            echo "✅ Quality Gate validée!"
                        }
                    }
                }
            }
        }

        // Étape 7: Build Docker Image
        stage('7. Docker Build') {
            steps {
                script {
                    sh '''
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''

                    sh 'docker images | grep student-management'
                    echo "✅ Image Docker créée: ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        // Étape 8: Push vers Docker Hub
        stage('8. Docker Push to Hub') {
            steps {
                script {
                    echo '🚀 Pushing to Docker Hub...'

                    withCredentials([string(credentialsId: 'docker-hub-password', variable: 'DOCKER_PASS')]) {
                        sh '''
                        echo ${DOCKER_PASS} | docker login -u ${DOCKER_REGISTRY} --password-stdin
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                        '''
                    }

                    echo "✅ Image poussée sur Docker Hub: ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    echo "📎 Lien: https://hub.docker.com/r/${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
                }
            }
        }
    }

    post {
        success {
            echo '🎉 PIPELINE COMPLET RÉUSSI !'
            echo '📦 JAR: target/student-management-0.0.1-SNAPSHOT.jar'
            echo '🐳 Image Docker: faresbelga/student-management:latest'
            echo '🔍 SonarQube: http://localhost:9000/dashboard?id=student-management'

            // Optionnel: Notification
            // emailext subject: 'Pipeline SUCCESS', body: 'Build réussi!'
        }
        failure {
            echo '❌ PIPELINE ÉCHOUÉ !'
            echo '📊 Voir les logs pour détails'

            // Optionnel: Notification
            // emailext subject: 'Pipeline FAILED', body: 'Build échoué!'
        }
        unstable {
            echo '⚠️ PIPELINE UNSTABLE (Quality Gate)'
            echo '🔍 Vérifie SonarQube: http://localhost:9000'
        }
    }
}