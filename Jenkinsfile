pipeline {
  agent any

  environment {
    AWS_CREDS = credentials('aws_creds') // Your Jenkins credential ID
    AWS_REGION = 'us-east-1'
    TF_VAR_aws_region = "${AWS_REGION}"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/MadalaSwetha/terraform-media-pipeline.git', branch: 'main'
      }
    }

    stage('Build Lambda') {
      steps {
        bat 'powershell Compress-Archive -Path lambda_function.py -DestinationPath lambda_function.zip -Force'
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'aws s3 cp lambda.zip s3://swetha-lambda-code-2026/lambda/media_lambda.zip'
        }
      }
    }

    stage('Terraform Init') {
      steps {
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'terraform init -reconfigure'
        }
      }
    }

    stage('Lint') {
      steps {
        bat 'terraform fmt -check'
      }
    }

    stage('Validate') {
      steps {
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'terraform validate'
        }
      }
    }

    stage('Plan') {
      steps {
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'terraform plan -out=tfplan'
          archiveArtifacts artifacts: 'tfplan', fingerprint: true
        }
      }
    }

    stage('Approval') {
      steps {
        input message: 'Apply infrastructure changes?'
      }
    }

    stage('Apply') {
      steps {
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'terraform apply -auto-approve tfplan'
        }
      }
    }

    stage('Post-Deploy') {
      steps {
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'terraform output || exit 0'

          script {
            def grafanaUrl = bat(script: "terraform output -raw grafana_url", returnStdout: true).trim()
            def prometheusUrl = bat(script: "terraform output -raw prometheus_url", returnStdout: true).trim()
            def jenkinsUrl = bat(script: "terraform output -raw jenkins_url", returnStdout: true).trim()

            echo "✅ Grafana available at: ${grafanaUrl}"
            echo "✅ Prometheus available at: ${prometheusUrl}"
            echo "✅ Jenkins available at: ${jenkinsUrl}"
          }
        }
      }
    }

    stage('Destroy (Optional)') {
      when {
        expression { return params.DESTROY == true }
      }
      steps {
        input message: 'Confirm destroy infrastructure?'
        withEnv([
          "AWS_ACCESS_KEY_ID=${env.AWS_CREDS_USR}",
          "AWS_SECRET_ACCESS_KEY=${env.AWS_CREDS_PSW}"
        ]) {
          bat 'terraform destroy -auto-approve'
        }
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
