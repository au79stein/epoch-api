# epoch-api

## Description
Create a basic API endpoint which responds to HTTP GET requests and returns a JSON payload in 
the form {"The current epoch time": <EPOCH_TIME>} where <EPOCH_TIME> is an integer representing the current epoch time in seconds.

## Additional Information
1. Provisioning script - provisions the infrastructure and code for the API
   - infrastructure? Assumes an existing and functional Kubernetes cluster
   - test cluster was provisioned using [terraform module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)
   - version 1.27 kubernetes
   - self-managed worker nodes
2. Provisioning
   - simplest method (implemented) is to download container image from [hub.docker.com](https://hub.docker.com)
   - run deployment to deploy pods
   - run with kubectl -n epoch-api apply -f epoch-api-deployment.yaml or possibly with bash script to insure creation of appropriate namespace
   - wont use helm for now

## Necessary Tools
1. running kubernetes cluster
2. kubectl is required: version 1.27 (+/-)

## GitHub
Files, etc can be accessed [here](https://github.com/au79stein/epoch-api)

## Installation

### Assumptions
It would be crazy to assume that you need to build an entire kubernetes cluster in order to deploy this simple
flask app.  Therefore, the assumption is made that a basic kubernetes cluster is already available.  If one is not
and you wish to create one, there are many possibiliies.  My recommendations of choice are kind or k3s [k3s here](https://k3s.io)
K3s running on a medium sized instance with a control plan and 3 nodes will provide all (most?) of what you need.

With all of that 'heavy lifting' trivialized and wiped away by assumption, the task at hand is to simply deploy the flask app
as a deployment (while not necessary, running a few copies/pods) of the app.  The app is launched, simply by declaratively 
deploying the pods and a loadbalancer service to make it available to the outside world.  If I have some time left, I 
will create a simple bash script to create the namespace and deploy both the service and the pods.  You can get carried away and 
create a Jenkins (or similar) pipeline that will do everything for you - which is fine if you already have a Jenkins environment
but if not, this is extra work (even using [JCasC](https://www.jenkins.io/projects/jcasc/)

### Steps


## References

### Building Container

```
 docker build -t epoch-api .
[+] Building 2.6s (12/12) FINISHED                                                                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                  0.5s
 => => transferring dockerfile: 232B                                                                                                                                                  0.2s
 => [internal] load .dockerignore                                                                                                                                                     0.4s
 => => transferring context: 2B                                                                                                                                                       0.1s
 => [internal] load metadata for docker.io/library/python:3.11-slim                                                                                                                   0.9s
 => [auth] library/python:pull token for registry-1.docker.io                                                                                                                         0.0s
 => [1/6] FROM docker.io/library/python:3.11-slim@sha256:cfd7ed5c11a88ce533d69a1da2fd932d647f9eb6791c5b4ddce081aedf7f7876                                                             0.0s
 => [internal] load build context                                                                                                                                                     0.1s
 => => transferring context: 1.05kB                                                                                                                                                   0.0s
 => CACHED [2/6] WORKDIR /app                                                                                                                                                         0.0s
 => CACHED [3/6] COPY requirements.txt .                                                                                                                                              0.0s
 => CACHED [4/6] RUN pip install Flask-RESTful                                                                                                                                        0.0s
 => CACHED [5/6] RUN pip install --no-cache-dir -r requirements.txt                                                                                                                   0.0s
 => [6/6] COPY . .                                                                                                                                                                    0.1s
 => exporting to image                                                                                                                                                                0.2s
 => => exporting layers                                                                                                                                                               0.2s
 => => writing image sha256:3668dcb4147410c3b158bb80515f56d3e194bebaa6b68a360012a86ebfed9e23                                                                                          0.0s
 => => naming to docker.io/library/epoch-api
```

### Testing Container Locally

```
$ docker run  -p 192.168.1.230:30000:8080 --rm epoch-api
 * Serving Flask app 'app'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:8080
 * Running on http://172.17.0.2:8080
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 106-496-095
192.168.1.230 - - [11/Dec/2023 19:48:40] "GET / HTTP/1.1" 200 -
```
or

```
$ docker compose up -d
[+] Running 10/10
 ✔ app 9 layers [⣿⣿⣿⣿⣿⣿⣿⣿⣿]      0B/0B      Pulled                                                                                                                                    1.0s
   ✔ 1f7ce2fa46ab Already exists                                                                                                                                                      0.0s
   ✔ f66cb2ec4ca8 Already exists                                                                                                                                                      0.0s
   ✔ 9e3072bcfe9d Already exists                                                                                                                                                      0.0s
   ✔ 4a2b4836be3f Already exists                                                                                                                                                      0.0s
   ✔ 312d1214a5ea Already exists                                                                                                                                                      0.0s
   ✔ 80e7fe659adf Already exists                                                                                                                                                      0.0s
   ✔ 81349d4faebc Already exists                                                                                                                                                      0.0s
   ✔ 56c4f3488845 Already exists                                                                                                                                                      0.0s
   ✔ 94d308a617e0 Already exists                                                                                                                                                      0.0s
[+] Running 1/1
 ✔ Container 02_docker-app-1  Started
```

```
curl 192.168.1.230:30000
{
  "The current epoch time": 1702324120
}
```

