pipeline {
  agent any

  

  stages {

    stage('Precheck') {
      steps {
        script {
          buildAnsibleStage("do_precheck")
          /*def response = sh(script: """
            curl -s -X POST ${AWX_URL}/api/v2/job_templates/${TEMPLATE_ID}/launch/ \\
              -H "Authorization: Bearer ${AWX_TOKEN}" \\
              -H "Content-Type: application/json" \\
              -d '{ "extra_vars": { "do_precheck": true } }'
          """, returnStdout: true).trim()*/

          echo "Precheck Job Response: ${response}"
        }
      }
    }

    stage('Patching') {
      steps {
        script {
          buildAnsibleStage("do_patch")
          /*def response = sh(script: """
            curl -s -X POST ${AWX_URL}/api/v2/job_templates/${TEMPLATE_ID}/launch/ \\
              -H "Authorization: Bearer ${AWX_TOKEN}" \\
              -H "Content-Type: application/json" \\
              -d '{ "extra_vars": { "do_patch": true } }'
          """, returnStdout: true).trim()*/

          echo "Patching Job Response: ${response}"
        }
      }
    }

    stage('Healthcheck') {
      steps {
        script {
          buildAnsibleStage("do_healthcheck")
          /*def response = sh(script: """
            curl -s -X POST ${AWX_URL}/api/v2/job_templates/${TEMPLATE_ID}/launch/ \\
              -H "Authorization: Bearer ${AWX_TOKEN}" \\
              -H "Content-Type: application/json" \\
              -d '{ "extra_vars": { "do_healthcheck": true } }'
          """, returnStdout: true).trim()*/

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

            echo "🎯 Triggering AWX Job Template #${jobTemplateId}"

            bat """
                curl -X POST ^
                  -H "Accept: application/json" ^
                  -H "Content-Type: application/json" ^
                  -H "Authorization: Bearer ${AWX_TOKEN}" ^
                  "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch/" ^
                  "-d '{ "extra_vars": { ${action}: true } }" ^
                  ", returnStdout: true).trim()"
            """
        }
    }
}
