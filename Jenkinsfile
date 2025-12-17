pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'faresbelga'
        DOCKER_IMAGE = 'student-management'
        DOCKER_TAG = 'latest'
    }

    stages {
        // Étape 1: Vérification des outils
        stage('0. Check Tools Installation') {
            steps {
                sh '''
                echo "🔍 Vérification des outils..."
                echo "Java version:"
                java --version
                echo ""
                echo "Maven version:"
                mvn --version
                echo ""
                echo "Docker version:"
                docker --version
                '''
            }
        }

        // Étape 2: Récupération du code
        stage('1. Checkout Git') {
            steps {
                checkout scm
                echo '📦 Code récupéré depuis GitHub'
            }
        }

        // Étape 3: Build Maven
        stage('2. Build Maven') {
            steps {
                sh 'mvn clean compile'
                echo '✅ Build réussi'
            }
        }

        // Étape 4: Tests
        stage('3. Tests') {
            steps {
                sh 'mvn test'
                echo '✅ Tests exécutés'
            }
        }

        // Étape 5: Package JAR
        stage('4. Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo '✅ JAR créé'
            }
        }

        // Étape 6: Analyse SonarQube
        stage('5. Analyse SonarQube') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube-Local') {
                        sh '''
                        mvn clean verify sonar:sonar \
                          -Dsonar.projectKey=student-management \
                          -Dsonar.projectName="Student Management" \
                          -Dsonar.host.url=http://localhost:9000 \
                          -Dsonar.login=admin \
                          -Dsonar.password=admin
                        '''
                    }
                }
            }
        }

        // Étape 7: Quality Gate
        stage('6. Quality Gate') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        echo "📊 Quality Gate Status: ${qg.status}"

                        if (qg.status != 'OK') {
                            // Warning mais continue
                            echo "⚠️ Quality Gate non passée, mais on continue..."
                            currentBuild.result = 'UNSTABLE'
                        } else {
                            echo "✅ Quality Gate validée !"
                        }
                    }
                }
            }
        }

        // Étape 8: Build Docker Image
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

        // Étape 9: Push vers Docker Hub
        stage('8. Docker Push to Hub') {
            steps {
                script {
                    echo '🚀 Pushing to Docker Hub...'

                    // Utilise les credentials Docker Hub
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
        always {
            echo "🔚 Pipeline terminé - Résultat: ${currentBuild.result}"

            // Nettoyage
            sh '''
            echo "Nettoyage..."
            docker system prune -f || true
            '''
        }
        success {
            echo '🎉 PIPELINE COMPLET RÉUSSI !'
            echo '📦 JAR: target/student-management-0.0.1-SNAPSHOT.jar'
            echo '🐳 Image Docker: faresbelga/student-management:latest'
            echo '🔍 SonarQube: http://localhost:9000/dashboard?id=student-management'
        }
        failure {
            echo '❌ PIPELINE ÉCHOUÉ !'
            echo '📋 Voir les logs pour détails'
        }
        unstable {
            echo '⚠️ PIPELINE UNSTABLE (Quality Gate non passée)'
            echo '🔍 Vérifie SonarQube: http://localhost:9000'
        }
    }
}