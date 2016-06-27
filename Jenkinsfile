node('jslave') {
    def workspace = pwd()
    def appname = 'goji_webapp'
    def progname = "goji-webapp"
    def registry_url = "registry.local:5000"
    def docker_hub_user = "maxor"
    def db_name = "gojidb"
    def db_root_passwd = "qwerty123"
    def db_user = "goji"
    def db_user_passwd = "goji123"
    def aws_instance = 'maxor-goji-webapp'

    stage 'Prepare'
    git url: 'https://github.com/maxim0r/golang-goji-sample.git', branch:"devel"

    stage "Build"
    docker.image('registry.local:5000/golang').inside {
        env.GOPATH="${env.HOME}/gocode"
        env.GOBIN="${env.GOPATH}/bin"
        env.PATH="${env.PATH}:/usr/local/go/bin:${env.GOBIN}"

        sh "go get"
        sh "go test"
        sh "go build -o $progname"
    }

    stage 'Build deploy app image'
    def appimg = docker.build("${docker_hub_user}/${appname}")

    stage 'Test image'
    docker.image("registry.local:5000/mysql:5.5").withRun(
        "-e MYSQL_ROOT_PASSWORD=$db_root_passwd -e MYSQL_DATABASE=$db_name -e MYSQL_USER=$db_user -e MYSQL_PASSWORD=$db_user_passwd"
        ) { dbc ->
        appimg.withRun("--link ${dbc.id}:appdb -p 8000:8000") { appc ->
            sh "docker logs $dbc.id"
            sh "docker logs $appc.id"
            sh "curl localhost:8000"
        }
    }

    stage 'Push to Docker hub registry'
    // not work
//    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub') {
    // docker.withRegistry('', 'docker_hub') {
    //     sh "docker login -u ${docker_hub_user} -p ${docker_hub_password}"
    //     appimg.push()
    // }
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'docker_hub',
        usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
        sh 'docker login --username $USERNAME --password $PASSWORD'
    }

    sh "docker push $docker_hub_user/$appname"
}

