pipeline {
  agent any

  environment {
    AWX_URL = "http://16.16.94.149"
    TEMPLATE_ID = "12"
  }

  stages {
    stage('Precheck') {
      steps {
        script {
          def response = buildAnsibleStage("do_precheck")
          echo "Precheck Job Response: ${response}"
        }
      }
    }

    stage('Patching') {
      steps {
        script {
          def response = buildAnsibleStage("do_patch")
          echo "Patching Job Response: ${response}"
        }
      }
    }

    stage('Healthcheck') {
      steps {
        script {
          def response = buildAnsibleStage("do_healthcheck")
          echo "Healthcheck Job Response: ${response}"
        }
      }
    }
  }
}

def buildAnsibleStage(String action) {
  withCredentials([string(credentialsId: 'ansible_token', variable: 'AWX_TOKEN')]) {
    script {
      def awxHost = "http://16.16.94.149"
      def jobTemplateId = 12

      echo "🎯 Triggering AWX Job Template #${jobTemplateId} for action: ${action}"

      def curlCommand = """
        curl -X POST ^
        -H "Accept: application/json" ^
        -H "Content-Type: application/json" ^
        -H "Authorization: Bearer ${AWX_TOKEN}" ^
        -d "{\\"extra_vars\\": {\\"${action}\\": true}}" ^
        "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch/"
      """

      // Capture and return response
      return bat(script: curlCommand, returnStdout: true).trim()
    }
  }
}
