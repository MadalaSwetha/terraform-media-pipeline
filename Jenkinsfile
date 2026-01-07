pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/MadalaSwetha/terraform-media-pipeline.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Approve deployment?"
                bat 'terraform apply tfplan'
            }
        }

        stage('Build WAR') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Deploy WAR to Tomcat') {
            steps {
                bat 'copy target\\myapp.war "C:\\apache-tomcat-10.1.XX\\webapps\\"'
            }
        }

        stage('Smoke Test') {
            steps {
                bat 'curl -I http://localhost:8080/myapp'
            }
        }
    }
}