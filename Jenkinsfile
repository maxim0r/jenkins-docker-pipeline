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

    // deploy environment
    def apphost = 'webapp'
    def appport = '8000'
    def extport = '80'
    def swarm_connector = "tcp://52.49.121.130:3376"
    def swarm_hostname = "max-swarm-master"
    def swarm_cert = "/home/jenkins/.docker/machine/machines/max-swarm-master"
    def proxy_image_name = "webapp-proxy"
    def proxy_container_name = "webproxy"

    stage 'Prepare'

    git url: 'https://github.com/maxim0r/golang-goji-sample.git', branch:"devel2"

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

    def appimg = docker.build("${docker_hub_user}/${appname}:latest")

    stage 'Build webapp-proxy image'

    sh "docker build -t ${docker_hub_user}/${proxy_image_name}:latest --no-cache --build-arg APPHOST=${apphost} --build-arg APPPORT=${appport} --build-arg EXPOSEPORT=${extport} ./${proxy_image_name}"

    stage 'Test image'

    docker.image("registry.local:5000/mysql:5.5").withRun(
        "-e MYSQL_ROOT_PASSWORD=$db_root_passwd -e MYSQL_DATABASE=$db_name -e MYSQL_USER=$db_user -e MYSQL_PASSWORD=$db_user_passwd"
        ) { dbc ->
        sh 'sleep 10'
        appimg.withRun("--link ${dbc.id}:appdb -p 8000:8000") { appc ->
            sh 'sleep 10'
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
    sh "docker push $docker_hub_user/${proxy_image_name}"
    
    stage 'Deploy'
    
    env.DOCKER_TLS_VERIFY="1"
    env.DOCKER_HOST=swarm_connector
    env.DOCKER_CERT_PATH=swarm_cert
    env.DOCKER_MACHINE_NAME=swarm_hostname

    sh "docker info"
    sh 'docker network ls'
    sh "docker pull $docker_hub_user/$appname"
    sh "docker pull $docker_hub_user/${proxy_image_name}"
    sh "docker pull nginx"
    sh "docker rm -f ${proxy_container_name} || echo ok"
    sh 'docker-compose -f deploy/docker-compose.yml ps'
    sh "docker-compose -f deploy/docker-compose.yml up -d --force-recreate"

}

