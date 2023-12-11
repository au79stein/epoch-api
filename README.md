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
3. git to clone the repo instead of copy-pasta

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
Sorry, I thought I would have more time to do this but this was a bad three days :)  
I took a bunch of short cuts in order to do this in a few hours today...

## Steps to Install and Run

On a server that has access to your kubernetes cluster...

1. Clone this repository
   ```git clone https://github.com/au79stein/epoch-api.git```

2. from within the repo:
   * from a bash cli, run
     ```bash run_endpoint_api.bash```

3. this should in *theory*
   * create a new namespace, epoch-api and make it the default 
   * run kubectl -f apply epoch-api-deployment.yaml
   * run kubectl -f apply epoch-api-lb.yaml
   * it should wait until the loadbalancer is spun-up but I ran out of time to do it the right way
   * it will sleep 15 seconds until at least in my environment the loadbalancer is running
   * it will return the endpoint to use for your curl commands
   * it will run an initial curl command and hopefully display the epoch time in seconds.



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

### push container image to hub.docker.com

```
$ docker tag epoch-api:latest datarich/epoch-api:latest
```

```
$ docker push datarich/epoch-api:latest
The push refers to repository [docker.io/datarich/epoch-api]
f6b229a42b87: Pushed
8fd6951d938e: Pushed
10ad1f76ec8b: Pushed
cb963b754be3: Layer already exists
3efcbcee67ed: Layer already exists
ec62b0a7261a: Layer already exists
4882946e114b: Layer already exists
644f76542c61: Layer already exists
74a2a09a3cec: Layer already exists
92770f546e06: Layer already exists
latest: digest: sha256:0d34ffcff5683e94500196092f673b11a5e87862838fffd0a5164f46a8a710bf size: 2410
```

### Creating k3s

creating an aws ec2 instance to run K3s... yeah, it is quicker and cheaper to test a deployment this way.  Better than minikube 
but not as good as the self-managed kubernetes cluster...but it will do for now.

```
$ terraform apply
data.http.my_public_ip: Reading...
data.http.my_public_ip: Read complete after 1s [id=https://ifconfig.co/json]
data.aws_instances.asg_instances: Reading...
data.aws_ami.amazon_linux: Reading...
data.aws_iam_policy_document.ec2-power-user: Reading...
data.aws_ami.amazon_linux_23: Reading...
data.aws_ami.ubuntu: Reading...
data.aws_instances.web_instances: Reading...
data.aws_route53_zone.terrorgrump: Reading...
data.aws_iam_policy_document.ec2-power-user: Read complete after 0s [id=3516061310]
data.aws_instances.asg_instances: Read complete after 0s [id=us-west-2]
data.aws_instances.web_instances: Read complete after 0s [id=us-west-2]
data.aws_ami.ubuntu: Read complete after 0s [id=ami-068510ecc618e49e3]
data.aws_ami.amazon_linux: Read complete after 0s [id=ami-07b9e09e662ee4b54]
data.aws_ami.amazon_linux_23: Read complete after 0s [id=ami-093467ec28ae4fe03]
data.aws_route53_zone.terrorgrump: Read complete after 0s [id=Z00896831OPBI1LS69CVT]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_autoscaling_group.ubserver_asg will be created
  + resource "aws_autoscaling_group" "ubserver_asg" {
      + arn                       = (known after apply)
      + availability_zones        = [
          + "us-west-2a",
        ]
      + default_cooldown          = (known after apply)
      + desired_capacity          = 1
      + force_delete              = false
      + force_delete_warm_pool    = false
      + health_check_grace_period = 300
      + health_check_type         = (known after apply)
      + id                        = (known after apply)
      + load_balancers            = (known after apply)
      + max_size                  = 1
      + metrics_granularity       = "1Minute"
      + min_size                  = 0
      + name                      = (known after apply)
      + name_prefix               = (known after apply)
      + predicted_capacity        = (known after apply)
      + protect_from_scale_in     = false
      + service_linked_role_arn   = (known after apply)
      + target_group_arns         = (known after apply)
      + vpc_zone_identifier       = (known after apply)
      + wait_for_capacity_timeout = "10m"
      + warm_pool_size            = (known after apply)

      + launch_template {
          + id      = (known after apply)
          + name    = (known after apply)
          + version = "$Latest"
        }

      + traffic_source {
          + identifier = (known after apply)
          + type       = (known after apply)
        }
    }

  # aws_iam_instance_profile.ec2-power-user will be created
  + resource "aws_iam_instance_profile" "ec2-power-user" {
      + arn         = (known after apply)
      + create_date = (known after apply)
      + id          = (known after apply)
      + name        = "ec2-power-user"
      + name_prefix = (known after apply)
      + path        = "/"
      + role        = "ec2-power-user"
      + tags_all    = (known after apply)
      + unique_id   = (known after apply)
    }

  # aws_iam_role.ec2-power-user will be created
  + resource "aws_iam_role" "ec2-power-user" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = [
                              + "ec2.amazonaws.com",
                              + "eks.amazonaws.com",
                              + "ssm.amazonaws.com",
                            ]
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "ec2-power-user"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags                  = {
          + "instance-profile-role" = "ec2-power-user"
        }
      + tags_all              = {
          + "instance-profile-role" = "ec2-power-user"
        }
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # aws_iam_role_policy.ec2-power-user will be created
  + resource "aws_iam_role_policy" "ec2-power-user" {
      + id     = (known after apply)
      + name   = "ec2-power-user"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "AllowActions"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # aws_launch_template.ubserver_lt will be created
  + resource "aws_launch_template" "ubserver_lt" {
      + arn             = (known after apply)
      + default_version = (known after apply)
      + id              = (known after apply)
      + image_id        = "ami-068510ecc618e49e3"
      + instance_type   = "t3.medium"
      + key_name        = "ghcir812"
      + latest_version  = (known after apply)
      + name            = "ubuntu_server_templ"
      + name_prefix     = (known after apply)
      + tags_all        = (known after apply)
      + user_data       = "IyEvYmluL2Jhc2gKc2V0IC14CgojIyMjIyMjIyMjIyMjIyMjIyMjCiMgYWRkIGRvY2tlciB1c2VyICMKIyMjIyMjIyMjIyMjIyMjIyMjIwp1c2VyYWRkIGRvY2tlcgoKIyBzaG91bGQgYmUgcmVtb3ZlZCBidXQgbWFrZXMgbXkgbGlmZSBzaW1wbGVyIC0gZG9uJ3QgcmVxdWlyZSBzdWRvIHBhc3N3ZCwgbGlrZSB1YnVudHUgdXNlcgplY2hvICdkb2NrZXIgQUxMPShBTEwpIE5PUEFTU1dEOkFMTCcgfCBFRElUT1I9J3RlZSAtYScgdmlzdWRvCgojIGFkZCBkb2NrZXIgZ3BnIGtleQpjdXJsIC1mc1NMIGh0dHBzOi8vZG93bmxvYWQuZG9ja2VyLmNvbS9saW51eC91YnVudHUvZ3BnIHwgYXB0LWtleSBhZGQgLQoKIyBhZGQgcmVwbyBhbmQgdXBkYXRlCmFkZC1hcHQtcmVwb3NpdG9yeSAiZGViIFthcmNoPWFtZDY0XSBodHRwczovL2Rvd25sb2FkLmRvY2tlci5jb20vbGludXgvdWJ1bnR1ICQobHNiX3JlbGVhc2UgLWNzKSBzdGFibGUiCmFwdC1nZXQgdXBkYXRlCgojIGluc3RhbGwgZG9ja2VyLWNlCmFwdC1nZXQgaW5zdGFsbCAteSBkb2NrZXItY2UKCiMgYWRkIHVzZXIgdG8gZG9ja2VyIGdyb3VwCnVzZXJtb2QgLWFHIGRvY2tlciB1YnVudHUKCiMgcHVsbCBuZ2lueCBpbWFnZQoKIyBydW4gY29udGFpbmVyIHdpdGggcG9ydCBtYXBwaW5nCgoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCiMgaW5zdGFsbCBrdWJlY3RsIGZvciB4ODYtNjQgIwojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKY3VybCAtTE8gImh0dHBzOi8vZGwuazhzLmlvL3JlbGVhc2UvJChjdXJsIC1MIC1zIGh0dHBzOi8vZGwuazhzLmlvL3JlbGVhc2Uvc3RhYmxlLnR4dCkvYmluL2xpbnV4L2FtZDY0L2t1YmVjdGwiCgojIGRvd25sb2FkIGNoZWNrc3VtCmN1cmwgLUxPICJodHRwczovL2RsLms4cy5pby8kKGN1cmwgLUwgLXMgaHR0cHM6Ly9kbC5rOHMuaW8vcmVsZWFzZS9zdGFibGUudHh0KS9iaW4vbGludXgvYW1kNjQva3ViZWN0bC5zaGEyNTYiCgojIHZhbGlkYXRlIGJpbmFyeSBhZ2FpbnN0IGNoZWNrc3VtCmVjaG8gIiQoY2F0IGt1YmVjdGwuc2hhMjU2KSAga3ViZWN0bCIgfCBzaGEyNTZzdW0gLS1jaGVjawoKaWYgW1sgJD8gPT0gMCBdXTsgdGhlbiAKCWVjaG8gImNoZWNrc3VtIGlzIGdvb2QiCmVsc2UKCWVjaG8gImNoZWNrc3VtIGlzIG5vIGdvb2QiCmZpCgojIGluc3RhbGwga3ViZWN0bAppbnN0YWxsIC1vIHJvb3QgLWcgcm9vdCAtbSAwNzU1IGt1YmVjdGwgL3Vzci9sb2NhbC9iaW4va3ViZWN0bAoKa3ViZWN0bCB2ZXJzaW9uIC0tY2xpZW50IC0tb3V0cHV0PXlhbWwKCiMgYXB0LWdldCB1cGRhdGUKIyBhcHQtZ2V0IGluc3RhbGwgLXkgY2EtY2VydGlmaWNhdGVzIGN1cmwKIyBjdXJsIC1mc1NMIGh0dHBzOi8vcGFja2FnZXMuY2xvdWQuZ29vZ2xlLmNvbS9hcHQvZG9jL2FwdC1rZXkuZ3BnIHwgc3VkbyBncGcgLS1kZWFybW9yIC1vIC9ldGMvYXB0L2tleXJpbmdzL2t1YmVybmV0ZXMtYXJjaGl2ZS1rZXlyaW5nLmdwZwojIGVjaG8gImRlYiBbc2lnbmVkLWJ5PS9ldGMvYXB0L2tleXJpbmdzL2t1YmVybmV0ZXMtYXJjaGl2ZS1rZXlyaW5nLmdwZ10gaHR0cHM6Ly9hcHQua3ViZXJuZXRlcy5pby8ga3ViZXJuZXRlcy14ZW5pYWwgbWFpbiIgfCBzdWRvIHRlZSAvZXRjL2FwdC9zb3VyY2VzLmxpc3QuZC9rdWJlcm5ldGVzLmxpc3QKIyBhcHQtZ2V0IHVwZGF0ZQojIGFwdC1nZXQgaW50YWxsIC15IGt1YmVjdGwKCgoKIyMjIyMjIyMjIyMjIyMjCiMgaW5zdGFsbCBrM2QgIwojIyMjIyMjIyMjIyMjIyMKYXB0LWdldCAteSBpbnN0YWxsIHdnZXQKd2dldCAtcSAtTyAtIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9rM2QtaW8vazNkL21haW4vaW5zdGFsbC5zaCB8IGJhc2gKCiMgY3JlYXRlIGNsdXN0ZXIKc3UgdWJ1bnR1ICAtYyAnL3Vzci9sb2NhbC9iaW4vazNkIGNsdXN0ZXIgY3JlYXRlIHRrYiAtLXNlcnZlcnMgMSAtLWFnZW50cyAzIC0taW1hZ2UgcmFuY2hlci9rM3M6bGF0ZXN0JwoKCgojIyMjIyMjIyMjIyMjIyMKIyBpbnN0YWxsIGdpdCAjCiMjIyMjIyMjIyMjIyMjIwphcHQtZ2V0IC15IGluc3RhbGwgZ2l0LWFsbAoKCgojIyMjIyMjIyMjIyMjIyMjIyMjCiMgaW5zdGFsbCBnb2xhbmc6ICMKIyMjIyMjIyMjIyMjIyMjIyMjIwpzdSB1YnVudHUgLWMgJ2NkIH4gJiYgY3VybCAtT0wgaHR0cHM6Ly9nby5kZXYvZGwvZ28xLjIwLjYubGludXgtYW1kNjQudGFyLmd6JwpzdSB1YnVudHUgLWMgJ3NoYTI1NnN1bSB+L2dvMS4yMC42LmxpbnV4LWFtZDY0LnRhci5neicKY2QgfnVidW50dSAmJiB0YXIgLUMgL3Vzci9sb2NhbCAteHZmIGdvMS4yMS4xLmxpbnV4LWFtZDY0LnRhci5negpzdSB1YnVudHUgLWMgJ2VjaG8gImV4cG9ydCBQQVRIPSRQQVRIOi91c3IvbG9jYWwvZ28vYmluIiAgPj4gfi8ucHJvZmlsZScKc3UgdWJ1bnR1IC1jICdzb3VyY2Ugfi8ucHJvZmlsZScKc3UgdWJ1bnR1IC1jICdnbyB2ZXJzaW9uJwoKCgojIyMjIyMjIyMjIyMjIyMjCiMgaW5zdGFsbCBqYXZhICMKIyMjIyMjIyMjIyMjIyMjIwpqYXZhIC12ZXJzaW9uCmFwdCB1cGRhdGUKYXB0IGluc3RhbGwgLXkgZGVmYXVsdC1qcmUKamF2YV92ZXJzaW9uPSQoamF2YSAtdmVyc2lvbikKZWNobyAiSkFWQV9WRVJTSU9OOiAke2phdmFfdmVyc2lvbn0iCgoKCiMjIyMjIyMjIyMjIyMjIwojIGNsb25lIHJlcG9zICMKIyMjIyMjIyMjIyMjIyMjCnN1IHVidW50dSAtYyAnbWtkaXIgL2hvbWUvdWJ1bnR1L1JlcG9zJwpzdSB1YnVudHUgLWMgJ2NkIC9ob21lL3VidW50dS9SZXBvcyAmJiBnaXQgY2xvbmUgaHR0cHM6Ly9naXRodWIuY29tL2F1NzlzdGVpbi9UaGVLOHNCb29rLmdpdCcKCiMgdGVtcG9yYXJ5IHJlcG9zaXRvcmllcyB0byB3b3JrIHdpdGgKI3N1IHVidW50dSAtYyAnY2QgL2hvbWUvdWJ1bnR1L1JlcG9zICYmIGdpdCBjbG9uZSBodHRwczovL2dpdGh1Yi5jb20vYXU3OXN0ZWluL2dvLXdlYi1zY3JhcGVyLmdpdCcKCgoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCiMgaW5zdGFsbCBhd3NjbGkgb24gaW5zdGFuY2UgIwojIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKZWNobyAiaW5zdGFsbGluZyBhd3NjbGkuLi4iCmFwdCBpbnN0YWxsIC15IGF3c2NsaQoKCgojIyMjIyMjIyMjIyMjIyMjIwojIGluc3RhbGwgdW56aXAgIwojIyMjIyMjIyMjIyMjIyMjIwoKZWNobyAiaW5zdGFsbGluZyB1bnppcC4uLiIKYXB0IGluc3RhbGwgLXkgdW56aXAKCgoKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKIyBpbnN0YWxsaW5nIGF3cy1zYW0tY2xpICMKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMKZWNobyAiZG93bmxvYWRpbmcgYXdzLXNhbS1jbGkuLi4gYW5kIGluc3RhbGxpbmcuLi4iCnN1IHVidW50dSAtYyAnd2dldCAtcSBodHRwczovL2dpdGh1Yi5jb20vYXdzL2F3cy1zYW0tY2xpL3JlbGVhc2VzL2xhdGVzdC9kb3dubG9hZC9hd3Mtc2FtLWNsaS1saW51eC14ODZfNjQuemlwJwpzdSB1YnVudHUgLWMgJ3VuemlwIGF3cy1zYW0tY2xpLWxpbnV4LXg4Nl82NC56aXAgLWQgc2FtLWluc3RhbGxhdGlvbicKc3UgdWJ1bnR1IC1jICdzdWRvIC4vc2FtLWluc3RhbGxhdGlvbi9pbnN0YWxsJwpzdSB1YnVudHUgLWMgJy91c3IvbG9jYWwvYmluL3NhbSAtLXZlcnNpb24nCgoKCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwojIGluc3RhbGwgbmV0LXRvb2xzIChuZWVkIGl0IGZvciB0ZXN0aW5naW5nIHBvcnRzLCBldGMpICMKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCmVjaG8gImluc3RhbGxpbmcgbmV0LXRvb2xzIChuZXRzdGF0LCBldGNoKS4uLiIKYXB0IGluc3RhbGwgLXkgbmV0LXRvb2xzCgoKCiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwojIGluc3RhbGwgZ3JhZmFuYS1lbnRlcnByaXNlICMKIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjCmVjaG8gImdldHRpbmcgZ3JhZmFuYSBlbnRlcnByaXNlIHNpZ25pbmcga2V5Li4uIgphcHQtZ2V0IGluc3RhbGwgLXkgYXB0LXRyYW5zcG9ydC1odHRwcwphcHQtZ2V0IGluc3RhbGwgLXkgc29mdHdhcmUtcHJvcGVydGllcy1jb21tb24gd2dldAp3Z2V0IC1xIC1PIC91c3Ivc2hhcmUva2V5cmluZ3MvZ3JhZmFuYS5rZXkgaHR0cHM6Ly9hcHQuZ3JhZmFuYS5jb20vZ3BnLmtleQoKZWNobyAiYWRkaW5nIHJlcG8gZm9yIHN0YWJsZSByZWxlYXNlcy4uLiIKZWNobyAiZGViIFtzaWduZWQtYnk9L3Vzci9zaGFyZS9rZXlyaW5ncy9ncmFmYW5hLmtleV0gaHR0cHM6Ly9hcHQuZ3JhZmFuYS5jb20gc3RhYmxlIG1haW4iIHwgc3VkbyB0ZWUgLWEgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvZ3JhZmFuYS5saXN0CmFwdC1nZXQgdXBkYXRlCgojIGZvciB0dXRvcmlhbCB3ZSBhcmUgdXNpbmcgb3BlbiBzb3VyY2UgdmVyc2lvbgoKZWNobyAiaW5zdGFsbGluZyBncmFmYW5hLWVudGVycHJpc2UuLi4iCiNhcHQtZ2V0IGluc3RhbGwgLXkgZ3JhZmFuYS1lbnRlcnByaXNlCmFwdC1nZXQgaW5zdGFsbCAteSBncmFmYW5hCgplY2hvICJzdGFydGluZyBzZXJ2aWNlcy4uLiIKc3lzdGVtY3RsIGRhZW1vbi1yZWxvYWQKCnN5c3RlbWN0bCBzdGFydCBncmFmYW5hLXNlcnZlcgoKc3lzdGVtY3RsIHN0YXR1cyBncmFmYW5hLXNlcnZlcgoKc3lzdGVtY3RsIGVuYWJsZSBncmFmYW5hLXNlcnZlci5zZXJ2aWNlCgoKCiMjIyMjIyMjIyMjIyMjIyMjCiMgaW5zdGFsbCBuZ2lueCAjCiMjIyMjIyMjIyMjIyMjIyMjCmVjaG8gImluc3RhbGxpbmcgYW5kIGNvbmZpZ3VyaW5nIG5naW54Li4uIgphcHQgaW5zdGFsbCAteSBuZ2lueApuZ2lueF92ZXJzaW9uPWBuZ2lueCAtdmAKZWNobyAiJG5naW54X3ZlcnNpb24iCgplY2hvICJzdG9wcGluZyBhcGFjaGUyIHdlYnNlcnZlci4uLiIKc3lzdGVtY3RsIHN0b3AgYXBhY2hlMgoKZWNobyAic3RhcnRpbmcgbmdpbnguLi4iCnN5c3RlbWN0bCBzdGFydCBuZ2lueAoKIyBzZXR1cCBuZ2lueCBhcyByZXZlcnNlIHByb3h5CmNkIC9ldGMvbmdpbngvc2l0ZXMtZW5hYmxlZAoKY2F0IDw8IEVPRiA+IGdyYWZhbmEudGVycm9yZ3J1bXAuY29tLmNvbmYKc2VydmVyIHsKICAgICAgICBsaXN0ZW4gODA7CiAgICAgICAgbGlzdGVuIFs6Ol06ODA7CiAgICAgICAgc2VydmVyX25hbWUgZ3JhZmFuYS50ZXJyb3JncnVtcC5jb207CgogICAgICAgICAgICAgICAgbG9jYXRpb24gLyB7CiAgICAgICAgICAgICAgICAgICAgICAgIHByb3h5X3Bhc3MgICAgICBodHRwOi8vbG9jYWxob3N0OjMwMDAvOwogICAgICAgICAgICAgICAgfQp9CkVPRgoKZWNobyAiY2hlY2tpbmcgbmdpbnggY29uZmlnLi4uIgpuZ2lueCAtdAoKZWNobyAic3RhcnRpbmcgbmdpbnguLi4iCnNlcnZpY2Ugbmdpbnggc3RhcnQKc3lzdGVtY3RsIHN0YXJ0IG5naW54CgpzZXQgK3gK"

      + iam_instance_profile {
          + name = "ec2-power-user"
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_protocol_ipv6          = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interfaces {
          + associate_public_ip_address = "true"
          + security_groups             = (known after apply)
        }

      + placement {}

      + tag_specifications {
          + resource_type = "instance"
          + tags          = {
              + "Name" = "generic_ubuntu_test"
            }
        }
    }

  # aws_route53_record.grafana will be created
  + resource "aws_route53_record" "grafana" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "grafana.terrorgrump.com"
      + records         = [
          + "54.212.24.1",
        ]
      + ttl             = 300
      + type            = "A"
      + zone_id         = "Z00896831OPBI1LS69CVT"
    }

  # module.security_group.aws_security_group.this_name_prefix[0] will be created
  + resource "aws_security_group" "this_name_prefix" {
      + arn                    = (known after apply)
      + description            = "Security group for example usage with EC2 instance"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = (known after apply)
      + name_prefix            = "kubernetes_the_hard_way_sg-"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "kubernetes_the_hard_way_sg"
        }
      + tags_all               = {
          + "Name" = "kubernetes_the_hard_way_sg"
        }
      + vpc_id                 = (known after apply)

      + timeouts {
          + create = "10m"
          + delete = "15m"
        }
    }

  # module.security_group.aws_security_group_rule.egress_rules[0] will be created
  + resource "aws_security_group_rule" "egress_rules" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + description              = "All protocols"
      + from_port                = -1
      + id                       = (known after apply)
      + ipv6_cidr_blocks         = [
          + "::/0",
        ]
      + prefix_list_ids          = []
      + protocol                 = "-1"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = -1
      + type                     = "egress"
    }

  # module.security_group.aws_security_group_rule.ingress_rules[0] will be created
  + resource "aws_security_group_rule" "ingress_rules" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + description              = "HTTP"
      + from_port                = 80
      + id                       = (known after apply)
      + ipv6_cidr_blocks         = []
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 80
      + type                     = "ingress"
    }

  # module.security_group.aws_security_group_rule.ingress_rules[1] will be created
  + resource "aws_security_group_rule" "ingress_rules" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + description              = "HTTPS"
      + from_port                = 443
      + id                       = (known after apply)
      + ipv6_cidr_blocks         = []
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 443
      + type                     = "ingress"
    }

  # module.security_group.aws_security_group_rule.ingress_rules[2] will be created
  + resource "aws_security_group_rule" "ingress_rules" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + description              = "SSH"
      + from_port                = 22
      + id                       = (known after apply)
      + ipv6_cidr_blocks         = []
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 22
      + type                     = "ingress"
    }

  # module.security_group.aws_security_group_rule.ingress_rules[3] will be created
  + resource "aws_security_group_rule" "ingress_rules" {
      + cidr_blocks              = [
          + "0.0.0.0/0",
        ]
      + description              = "All IPV4 ICMP"
      + from_port                = -1
      + id                       = (known after apply)
      + ipv6_cidr_blocks         = []
      + prefix_list_ids          = []
      + protocol                 = "icmp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = -1
      + type                     = "ingress"
    }

  # module.security_group.aws_security_group_rule.ingress_with_cidr_blocks[0] will be created
  + resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
      + cidr_blocks              = [
          + "149.57.0.0/16",
        ]
      + description              = " port 8080 for access"
      + from_port                = 8080
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 8080
      + type                     = "ingress"
    }

  # module.security_group.aws_security_group_rule.ingress_with_cidr_blocks[1] will be created
  + resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
      + cidr_blocks              = [
          + "149.57.0.0/16",
        ]
      + description              = " port 3000 for access"
      + from_port                = 3000
      + id                       = (known after apply)
      + prefix_list_ids          = []
      + protocol                 = "tcp"
      + security_group_id        = (known after apply)
      + security_group_rule_id   = (known after apply)
      + self                     = false
      + source_security_group_id = (known after apply)
      + to_port                  = 3000
      + type                     = "ingress"
    }

Plan: 14 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ids                   = []
  + instance_state_privip = []
  + instance_state_pubip  = []
  + my_ip_addr            = "154.6.13.143"

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

duh... it isn't running anymore... nothing to see here:

```
  # aws_launch_template.ubserver_lt will be updated in-place
  ~ resource "aws_launch_template" "ubserver_lt" {
        id                      = "lt-0191557ffeb2c0c09"
      ~ latest_version          = 1 -> (known after apply)
        name                    = "ubuntu_server_templ"
        tags                    = {}
        # (11 unchanged attributes hidden)

      + placement {}

        # (3 unchanged blocks hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Changes to Outputs:
  ~ ids                   = [
      + "i-0d7a1cc94a2210316",
    ]
  ~ instance_state_privip = [
      + "172.31.22.66",
    ]
  ~ instance_state_pubip  = [
      + "35.91.88.195",
    ]

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_launch_template.ubserver_lt: Modifying... [id=lt-0191557ffeb2c0c09]
aws_launch_template.ubserver_lt: Modifications complete after 1s [id=lt-0191557ffeb2c0c09]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

ids = tolist([
  "i-0d7a1cc94a2210316",
])
instance_state_privip = tolist([
  "172.31.22.66",
])
instance_state_pubip = tolist([
  "35.91.88.195",
])
```

```
$ ec2-ssh 35.91.88.195
The authenticity of host '35.91.88.195 (35.91.88.195)' can't be established.
ED25519 key fingerprint is SHA256:fSnOfJGEMvh5odl7RKkJDk5ZXwnT32U9+kV33+g/63s.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '35.91.88.195' (ED25519) to the list of known hosts.
Welcome to Ubuntu 23.04 (GNU/Linux 6.2.0-1017-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 2.0

11 updates can be applied immediately.
9 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

```

```
$ tail -f /var/log/cloud-init-output.log
.
.
+ nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
+ echo 'starting nginx...'
starting nginx...
+ service nginx start
+ systemctl start nginx
+ set +x
Cloud-init v. 23.3.3-0ubuntu0~23.04.1 finished at Mon, 11 Dec 2023 20:19:00 +0000. Datasource DataSourceEc2Local.  Up 318.84 seconds
.
.
```

```
ubuntu@ip-172-31-22-66:~$ k3d cluster list --verbose
DEBU[0000] DOCKER_SOCK=/var/run/docker.sock
DEBU[0000] Runtime Info:
&{Name:docker Endpoint:/var/run/docker.sock Version:24.0.7 OSType:linux OS:Ubuntu 23.04 Arch:x86_64 CgroupVersion:2 CgroupDriver:systemd Filesystem:extfs InfoName:ip-172-31-22-66}
DEBU[0000] Found 5 nodes
DEBU[0000] Found 1 clusters
NAME   SERVERS   AGENTS   LOADBALANCER
tkb    1/1       3/3      true


ubuntu@ip-172-31-22-66:~$ k3d node list
NAME               ROLE           CLUSTER   STATUS
k3d-tkb-agent-0    agent          tkb       running
k3d-tkb-agent-1    agent          tkb       running
k3d-tkb-agent-2    agent          tkb       running
k3d-tkb-server-0   server         tkb       running
k3d-tkb-serverlb   loadbalancer   tkb       running
ubuntu@ip-172-31-22-66:~$
```


