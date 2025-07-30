pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    booleanParam(name: 'AUTO_APPLY', defaultValue: false, description: 'Auto-apply Terraform changes?')
  }

  environment {
    TF_WORKING_DIR = "envs/${params.ENV}"
  }

  stages {
    stage('Terraform Init') {
      steps {
        dir("${TF_WORKING_DIR}") {
          sh 'terraform init -backend-config=backend.tf'
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        dir("${TF_WORKING_DIR}") {
          sh 'terraform validate'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("${TF_WORKING_DIR}") {
          sh 'terraform plan -out=tfplan'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.AUTO_APPLY }
      }
      steps {
        dir("${TF_WORKING_DIR}") {
          sh 'terraform apply -auto-approve tfplan'
        }
      }
    }
  }
}
