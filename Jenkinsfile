pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "seifkhaled123/flask-app:latest"
        DOCKERHUB_CREDENTIALS = "dockerhub-cred"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-ssh',
                    url: 'git@github.com:Seif-k123/automated-deployment-platform.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build --provenance=false -t $DOCKER_IMAGE ./app'
            }
        }
        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }
        stage('Push Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }
         stage('Terraform Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    cd terraform
                    terraform init
                    terraform apply -auto-approve
                    '''
                }
            }
        }
        stage('Run Ansible') {
            steps {
                sh '''
                cd ansible
                ansible-playbook -i inventory playbook.yml
                '''
            }
        }
    }
    post {
        success {
            echo "Pipeline Success 🚀"
        }
        failure {
            echo "Pipeline Failed ❌"
        }
    }
}
