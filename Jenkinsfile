node {
    def commit_id
    stage('Preparation') {
        checkout scm
        sh "git rev-parse --short HEAD > .git/commit-id"                        
        commit_id = readFile('.git/commit-id').trim()
    }
    stage('Docker build/push') {
        docker.withRegistry('http://docker-registry:5000/v2', '') {
        def app = docker.build("docker-registry/purr:${commit_id}", '.').push()
        }
    }
}