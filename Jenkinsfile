pipeline {
  agent any

  environment {
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
        // Package the Lambda function file into a zip
        bat 'powershell Compress-Archive -Path lambda_function.py -DestinationPath lambda_function.zip -Force'

        // Upload to S3 bucket
        withCredentials([usernamePassword(credentialsId: 'aws_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          bat 'aws s3 cp lambda_function.zip s3://swetha-lambda-code-2026/lambda/media_lambda.zip'
        }
      }
    }

    stage('Terraform Init') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_creds']]) {
          bat 'terraform init -reconfigure'
        }
      }
    }

    stage('Validate') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          bat 'terraform validate'
        }
      }
    }

    stage('Plan') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
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
        withCredentials([usernamePassword(credentialsId: 'aws_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
          bat 'terraform apply -auto-approve tfplan'
        }
      }
    }

    stage('Post-Deploy') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
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
        withCredentials([usernamePassword(credentialsId: 'aws_creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
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
