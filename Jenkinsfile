pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    booleanParam(name: 'AUTO_APPLY', defaultValue: false, description: 'Auto-apply Terraform changes?')
  }

  environment {
    TF_WORKING_DIR = "envs/${params.ENV}"
    PATH = "$HOME/bin:$PATH" // This makes Terraform and AWS CLI available everywhere
  }

  stages {
    stage('Install Tools') {
      steps {
        sh '''
          echo "Install AWS CLI, or update if already installed"
          curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
          unzip -q -o awscliv2.zip
          ./aws/install --install-dir ~/my-aws-cli --bin-dir ~/bin --update

          echo "Install Terraform locally"
          curl -fsSL https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip -o terraform.zip
          unzip -o terraform.zip
          mkdir -p $HOME/bin
          mv terraform $HOME/bin/

          echo "PATH after install:"
          echo $PATH
          terraform version
        '''
      }
    }

    stage('Terraform Operations') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          script {
            dir("${TF_WORKING_DIR}") {
              sh 'terraform init'
              sh 'terraform validate'
              sh 'terraform plan -out=tfplan'
              if (params.AUTO_APPLY) {
                sh 'terraform apply -auto-approve tfplan'
              }
            }
          }
        }
      }
    }
  }
}
