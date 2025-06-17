pipeline {
  agent any

  environment {
    AWX_HOST = "http://16.16.94.149"               // Ansible Tower URL
    AWX_TOKEN = credentials('ansible_token')   // Jenkins secret text credential
    JOB_TEMPLATE_ID = "12"                     // AWX Job Template ID
  }

  stages {
    stage('Checkout Code') {
      steps {
        deleteDir()
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build("my-python-app:${BUILD_NUMBER}")
        }
      }
    }

    /*stage('Trigger Ansible Tower') {
      steps {
        script {
          echo "Triggering Ansible Job on AWX..."
          sh """
            curl -X POST $AWX_HOST/api/v2/job_templates/$JOB_TEMPLATE_ID/launch \\
              -H "Authorization: Bearer $AWX_TOKEN" \\
              -H "Content-Type: application/json"
          """
        }
      }
    }*/

    
  }
}
