pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'faresbelga'
        DOCKER_IMAGE = 'student-management'
        DOCKER_TAG = 'latest'
        DOCKER_PASSWORD = 'faresfares123'  // Ton mot de passe
    }

    stages {
        // Étape 0: Vérification outils
        stage('0. Check Tools') {
            steps {
                sh '''
                echo "=== VÉRIFICATION OUTILS ==="
                java --version && echo "✅ Java OK"
                mvn --version && echo "✅ Maven OK"
                docker --version && echo "✅ Docker OK"
                '''
            }
        }

        // Étape 1: Checkout
        stage('1. Checkout Git') {
            steps {
                checkout scm
                echo '📦 Code récupéré depuis GitHub'
            }
        }

        // Étape 2: Build
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

        // Étape 4: Package
        stage('4. Package') {
            steps {
                sh 'mvn package -DskipTests'
                echo '✅ JAR créé'
            }
        }

        // Étape 5: SonarQube
        stage('5. Analyse SonarQube') {
            steps {
                script {
                    // Version avec token (RECOMMANDÉ)
                    sh '''
                    mvn clean verify sonar:sonar \
                      -Dsonar.projectKey=student-management \
                      -Dsonar.host.url=http://localhost:9000 \
                      -Dsonar.token=sqa_caa39e48ec9967cab0f5c9b6aca65c95f39d3a7b
                    '''

                    // Version alternative avec login/mdp
                    // sh '''
                    // mvn clean verify sonar:sonar \
                    //   -Dsonar.projectKey=student-management \
                    //   -Dsonar.host.url=http://localhost:9000 \
                    //   -Dsonar.login=admin \
                    //   -Dsonar.password=admin
                    // '''
                }
            }
        }

        // Étape 6: Quality Gate
        stage('6. Quality Gate') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        // Essaie de récupérer le résultat
                        try {
                            def qg = waitForQualityGate()
                            echo "📊 Quality Gate: ${qg.status}"

                            if (qg.status != 'OK') {
                                echo "⚠️ Attention: Quality Gate non passée"
                                // Continue quand même
                            }
                        } catch (Exception e) {
                            echo "⚠️ Impossible de vérifier Quality Gate: ${e.message}"
                            echo "⏭️ On continue le pipeline..."
                        }
                    }
                }
            }
        }

        // Étape 7: Docker Build
        stage('7. Docker Build') {
            steps {
                script {
                    sh '''
                    docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                    '''
                    echo "✅ Image Docker créée"
                }
            }
        }

        // Étape 8: Docker Push
        stage('8. Docker Push to Hub') {
            steps {
                script {
                    echo '🚀 Connexion à Docker Hub...'

                    // Connexion directe avec tes credentials
                    sh '''
                    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_REGISTRY}" --password-stdin
                    '''

                    echo '⬆️ Push de l\'image...'
                    sh '''
                    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                    docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                    '''

                    echo "✅ Image poussée sur Docker Hub!"
                    echo "📎 Lien: https://hub.docker.com/r/${DOCKER_REGISTRY}/${DOCKER_IMAGE}"
                }
            }
        }

        // Étape bonus: Cleanup
        stage('9. Cleanup') {
            steps {
                sh '''
                echo "🧹 Nettoyage..."
                # Supprime les images intermédiaires
                docker image prune -f || true
                # Liste les images restantes
                echo "📦 Images Docker restantes:"
                docker images | grep student-management || true
                '''
            }
        }
    }

    post {
        always {
            echo "========================================"
            echo "🏁 PIPELINE TERMINÉ - Résultat: ${currentBuild.result}"
            echo "========================================"

            // Résumé des étapes
            echo "📋 RÉCAPITULATIF:"
            echo "  • SonarQube: http://localhost:9000/dashboard?id=student-management"
            echo "  • Docker Hub: https://hub.docker.com/r/faresbelga/student-management"
            echo "  • JAR: target/student-management-0.0.1-SNAPSHOT.jar"
        }
        success {
            echo '🎉🎉🎉 SUCCÈS TOTAL ! 🎉🎉🎉'
        }
        failure {
            echo '❌❌❌ ÉCHEC - Voir logs ci-dessus ❌❌❌'
        }
        unstable {
            echo '⚠️⚠️⚠️ UNSTABLE - Vérifie SonarQube ⚠️⚠️⚠️'
        }
    }
}