pipeline {
  agent {
    label "jenkins-jx-base"
  }
  environment {
    ORG = 'hebersonaguiar'
    APP_NAME = 'ditochatbackend'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    DOCKER_REGISTRY_ORG = 'challengedito-255115'
  }
  stages {
    stage('Build Release') {
      when {
        branch 'master'
      }
      steps {
        container('jx-base') {

          // ensure we're not on a detached head
          sh "git checkout master"
          sh "git config --global credential.helper store"
          sh "jx step git credentials"
          sh "jx step next-version --use-git-tag-only --tag"
          sh "export VERSION=`cat VERSION` && skaffold build -f skaffold.yaml"
          sh "jx step post build --image $DOCKER_REGISTRY/$ORG/$APP_NAME:\$(cat VERSION)"
        }
      }
    }
    stage('Promote to Environments') {
      when {
        branch 'master'
      }
      steps {
        container('jx-base') {
          dir('./charts/ditochatbackend') {
            sh "jx step changelog --version v\$(cat ../../VERSION)"

            // release the helm chart
            sh "jx step helm release"

            // promote through all 'Auto' promotion Environments
            // sh "jx promote -b --all-auto --timeout 1h --version \$(cat ../../VERSION) --no-wait=true --no-poll=true"
            sh "jx promote -b --all-auto --timeout 1h --version \$(cat ../../VERSION)"
          }
        }
      }
    }
  }
  post {
        always {
          cleanWs()
        }
  }
}
