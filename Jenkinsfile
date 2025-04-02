pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'rajcosivadevops/cicdncplimage'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Docker Login & Pull') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhublogin', 
                        usernameVariable: 'DOCKER_USER', 
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    }

                    sh "docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Stop and remove existing container if running
                    sh "docker rm -f springboot-container || true"

                    // Run new container with specific name
                    sh "docker run -d --name springboot-container -p 8081:9090 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
    }
}
