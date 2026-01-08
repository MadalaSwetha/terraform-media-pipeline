// Jenkinsfile
pipeline {
  agent any
  environment {
    AWS_REGION = 'us-east-1'
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/MadalaSwetha/terraform-media-pipeline.git', branch: 'main'
      }
    }
    stage('Terraform Init') {
      steps { sh 'terraform init -reconfigure' }
    }
    stage('Lint') {
      steps { sh 'terraform fmt -check' }
    }
    stage('Validate') {
      steps { sh 'terraform validate' }
    }
    stage('Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
        archiveArtifacts artifacts: 'tfplan', fingerprint: true
      }
    }
    stage('Approval') {
      steps { input message: 'Apply infrastructure changes?' }
    }
    stage('Apply') {
      steps { sh 'terraform apply -auto-approve tfplan' }
    }
    stage('Post-Deploy') {
      steps {
        sh 'terraform output || true'
        sh 'echo "Jenkins: $JENKINS_URL" || true'
      }
    }
  }
}