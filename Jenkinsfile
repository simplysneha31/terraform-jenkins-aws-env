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
    stage('Install Tools') {
      steps {
        sh '''
          echo "Install AWS CLI"
          curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
          unzip awscliv2.zip
          sudo ./aws/install

          echo "Install Terraform"
          curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
          echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
          sudo apt-get update && sudo apt-get install -y terraform
        '''
      }
    }
    stage('Terraform Init') {
      steps {
      withCredentials([
        string(credentialsId: 'aws-access-key', variable: 'AWS_ACCESS_KEY_ID'),
        string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_KEY_ID'),
      ])
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
