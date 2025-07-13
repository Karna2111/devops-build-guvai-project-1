pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'karna2111'
        DEV_REPO = 'karna2111/dev'
        PROD_REPO = 'karna2111/prod'
        IMAGE_NAME = 'react-static-app'
    }

    options {
        skipStagesAfterUnstable()
    }

    triggers {
        githubPush() // Webhook-based trigger from GitHub
    }

    stages {

        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }

        stage('Push Docker Image') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'master'
                }
            }
            steps {
                script {
                    sh 'chmod +x deploy.sh'
                    if (env.BRANCH_NAME == 'dev') {
                        sh './deploy.sh dev'
                    } else if (env.BRANCH_NAME == 'master') {
                        sh './deploy.sh prod'
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(credentials: ['ec2-ssh-key']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@<54.234.29.140> "docker pull $DOCKER_HUB_USER/$IMAGE_NAME && docker stop web || true && docker rm web || true && docker run -d -p 80:80 --name web $DOCKER_HUB_USER/$IMAGE_NAME"'
                }
            }
        }
    }

    post {
        failure {
            mail to: 'karnamaharajan.d@gmail.com',
                 subject: "Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Check Jenkins at ${env.BUILD_URL}"
        }
    }
}
