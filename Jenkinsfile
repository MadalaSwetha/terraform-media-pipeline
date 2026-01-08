pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    TF_VAR_aws_region = "${AWS_REGION}"
    // Bind AWS credentials securely in Jenkins (Manage Jenkins → Credentials)
    AWS_ACCESS_KEY_ID = credentials('aws-access-key')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
  }

  stages {
    stage('Checkout') {
  steps {
    git url: 'https://github.com/MadalaSwetha/terraform-media-pipeline.git',
        branch: 'main',
        tool: 'DefaultGit'
  }
}

    stage('Terraform Init') {
      steps {
        bat 'terraform init -reconfigure'
      }
    }

    stage('Lint') {
      steps {
        bat 'terraform fmt -check'
      }
    }

    stage('Validate') {
      steps {
        bat 'terraform validate'
      }
    }

    stage('Plan') {
      steps {
        bat 'terraform plan -out=tfplan'
        archiveArtifacts artifacts: 'tfplan', fingerprint: true
      }
    }

    stage('Approval') {
      steps {
        input message: 'Apply infrastructure changes?'
      }
    }

    stage('Apply') {
      steps {
        bat 'terraform apply -auto-approve tfplan'
      }
    }

    stage('Post-Deploy') {
      steps {
        // Show Terraform outputs (Grafana, Prometheus, Jenkins, S3, Lambda)
        bat 'terraform output || exit 0'

        script {
          def grafanaUrl = bat(script: "terraform output -raw grafana_url", returnStdout: true).trim()
          def prometheusUrl = bat(script: "terraform output -raw prometheus_url", returnStdout: true).trim()
          def jenkinsUrl = bat(script: "terraform output -raw jenkins_url", returnStdout: true).trim()
          echo "Grafana available at: ${grafanaUrl}"
          echo "Prometheus available at: ${prometheusUrl}"
          echo "Jenkins available at: ${jenkinsUrl}"
        }
      }
    }

    stage('Destroy (Optional)') {
      when {
        expression { return params.DESTROY == true }
      }
      steps {
        input message: 'Confirm destroy infrastructure?'
        bat 'terraform destroy -auto-approve'
      }
    }
  }

  post {
    always {
      echo "Pipeline finished. Check Terraform state and outputs."
    }
    success {
      echo "Infrastructure applied successfully!"
    }
    failure {
      echo "Pipeline failed. Investigate logs."
    }
  }
}
