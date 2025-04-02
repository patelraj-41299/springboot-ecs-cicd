pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        ECR_REPO_NAME = 'springboot-app'
        ECR_URI = "060795913786.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_TAG = 'latest'
        GIT_CREDENTIALS_ID = 'github-creds'
        AWS_CREDENTIALS_ID = 'alogin' // ✅ Your AWS credential ID in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", url: 'https://github.com/patelraj-41299/springboot-ecs-cicd.git', branch: 'main'
            }
        }

        stage('Build Spring Boot App') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $ECR_REPO_NAME:$IMAGE_TAG .'
            }
        }

        stage('Login to ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "${AWS_CREDENTIALS_ID}"
                ]]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_REGION | \
                        docker login --username AWS --password-stdin $ECR_URI
                    '''
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh '''
                    docker tag $ECR_REPO_NAME:$IMAGE_TAG $ECR_URI/$ECR_REPO_NAME:$IMAGE_TAG
                    docker push $ECR_URI/$ECR_REPO_NAME:$IMAGE_TAG
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "alogin"
                ]]) {
                    sh '''
                        echo "🧪 AWS Access Key: $AWS_ACCESS_KEY_ID"

                        aws ecs update-service \
                          --cluster springboot-cluster \
                          --service springboot-service \
                          --force-new-deployment \
                          --region us-east-2
                    '''
                }
            }
        }
    }

    post {
        always {
            echo '✅ Pipeline finished. Cleaning up Docker image...'
            sh 'docker rmi $ECR_URI/$ECR_REPO_NAME:$IMAGE_TAG || true'
        }
    }
}

