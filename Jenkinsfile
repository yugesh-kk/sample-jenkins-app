pipeline {
  agent any

  stages{
    stage ('Create a Dir'){
      steps {
        script{
          
        }
      }
    }


    // pipeline & stage
  }
}

def ansible_call () {
   withCredentials([string(credentialsId: 'ansible_token', variable: 'AWX_TOKEN')]) {
     script {
        def awxHost = "http://16.16.94.149"
        def jobTemplateId = 11

        echo "🎯 Triggering AWX Job Template #${jobTemplateId}"
        bat """
       curl -X POST ^
       -H "Accept: application/json" ^
       -H "Content-Type: application/json" ^
       -H "Authorization: Bearer ${AWX_TOKEN}" ^
       "${awxHost}/api/v2/job_templates/${jobTemplateId}/launch"
       
       """
     }
   }
}
