# localops

[Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) to manage installation and configuration of local environments.

You may be interested in this project if:

1. You constantly need to set up computers for your own use, with different configurations each time (my personal motivation);
1. You manage several distinct computer configurations, and are just plain tired of doing so manually, having to remember every little detail and difference each one has (come to think of it, my personal motivation, too).

The existing playbooks suit my particular needs and may, or may not, interest you. Some perform very basic tasks, like installing Google Chrome or LibreOffice; others will go as far as installing Jenkins and Nginx, configuring the latter to proxy the former using HTTPS. One usually does not need to run such services locally, I do so to test and develop CI/CD pipelines and the like, hopefully someone else may benefit from them.

## Currently supported distros:

* [Ubuntu 18.04 (Bionic Beaver)](http://releases.ubuntu.com/18.04/)
* [Ubuntu 20.04 (Focal Fossa)](http://releases.ubuntu.com/20.04/)

[Ubuntu 16.04 (Xenial Xerus)](http://releases.ubuntu.com/16.04/) is neither supported (if you find bugs, I will not fix them) nor was extensively tested, but some people did install localops in it and used it successfully.

## Installation

Ansible is not supported by Ubuntu out of the box, so we need to install it.

Check this repository out (you may need to "sudo apt install git" first):

`git clone git@github.com:gasrios/localops.git`

From within directory "localops", run:

`./bootstrap.sh`

If asked, inform your password (localops uses `sudo` to install APT packages).

What does bootstrap.sh do? It...

1. Installs apt package "python3-pip";
1. Uses command "pip3", provided by the package, to install pip using the [user scheme](https://docs.python.org/3/install/index.html#alternate-installation-the-user-scheme), which from this point on manages itself (you can update/uninstall pip using pip)
1. Uninstalls apt package "python3-pip" and its dependencies;
1. Installs Ansible using pip

## Using localops

After installation, you can install additional sofwares from the command line by running the following command, from localops root directory:

`./localops-cli.sh ${PLAYBOOK_NAME}`

## Currently Available Playbooks

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* Local [certificate authority](https://en.wikipedia.org/wiki/Certificate_authority)
* [Codacy Analysis CLI](https://github.com/codacy/codacy-analysis-cli)
* [curl](https://curl.haxx.se/)
* [direnv](https://github.com/direnv/direnv)
* [Docker](https://www.docker.com/)
* [Docker local registry](https://docs.docker.com/registry/insecure/) as [systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html) service
* [Dropbox](https://www.dropbox.com/)
* [GitHub CLI](https://cli.github.com/)
* [Google Chrome](https://www.google.com/chrome)
* [Google Cloud SDK](https://cloud.google.com/sdk)
* [IntelliJ](https://www.jetbrains.com/idea/)
* [Java](https://openjdk.java.net/)
* [Jenkins](https://jenkins.io/)
* [Jupyter](https://jupyter.org/)
* [kubectl CLI](https://kubernetes.io/docs/reference/kubectl/)
* [LibreOffice](https://www.libreoffice.org/)
* [LocalStack](https://localstack.cloud/)
* [MicroK8s](https://microk8s.io/) **(see note below!)** and [Kubeval](https://github.com/instrumenta/kubeval)
* [NFS Server](https://tools.ietf.org/html/rfc5661)
* [Nginx](https://nginx.org/en/)
* [Packer](https://packer.io/) by Hashicorp
* [Pulse Secure](https://www.pulsesecure.net/)
* [Salesforce](https://www.salesforce.com/)
* [Slack](https://slack.com/)
* [Spotify for Linux](https://www.spotify.com/br/download/linux/)
* [Spring Cloud CLI](https://spring.io/projects/spring-cloud-cli)
* [Terraform](https://www.terraform.io/) by Hashicorp
* [VirtualBox](https://www.virtualbox.org/)
* [Visual Studio Code](https://code.visualstudio.com/)

Some of the above do nothing beyond installing packages from official Ubuntu repositories, which may seem to be overkill. Still, having a playbook might be useful, as it can be imported by other playbook to orchestrate installation of complex environments, and/or add additional configuration to them.

**Attention MicroK8s users:** MicroK8s [can't reach the internet](https://microk8s.io/docs/troubleshooting#heading--common-issues).

If you need your microk8s cluster to access the Internet, localops provides script [microk8s/ufw-allow-microk8s.sh](https://github.com/gasrios/localops/blob/master/microk8s/ufw-allow-microk8s.sh) to help you configure your firewall. However, localops **DOES NOT** execute it, as this might be a security issue. Please review and customize it as you see fit, given your use cases.

Even after correctly configuring your firewall, you may experience connectivity issues, after rebooting. Running "microk8s stop" before shutting down should prevent them from happening and, even if they do, "microk8s stop" and "microk8s start" should fix them.

## Testing

* [test/prepare-test.sh](https://github.com/gasrios/localops/blob/master/test/prepare-test.sh) creates "base" Docker test images. "Vanilla" Ubuntu Docker images do not have all the packages you would expect to find in an Ubuntu desktop, so we add the bare minimum that ensurer compatibility.

* [test/test.sh](https://github.com/gasrios/localops/blob/master/test/test.sh) runs the installation process in all supported environments.

A few Docker commands that might help (**use them carefully, as they might delete other Docker images and containers you have available locally**):

```
# Lists all existing images and containers
clear; docker image ls -a; echo; docker container ls -a

# Deletes test containers
docker container rm $(docker container ls -a | egrep '/bin/bash' | awk '{print $1}')

# Deletes test images
docker image rm localops:ubuntu-20.04
docker image rm localops:ubuntu-18.04

# Runs images in "manual test" mode
docker run -it localops:ubuntu-20.04 '/bin/bash'
docker run -it localops:ubuntu-18.04 '/bin/bash'

# Backups base test images
docker save --output ~/localops_images/ubuntu-18.04-base.tar ${UBUNTU_18.04_IMAGE_ID}
docker save --output ~/localops_images/ubuntu-20.04-base.tar ${UBUNTU_20.04_IMAGE_ID}

# Cleans up all images (removes intermediary images)
docker image prune -fa

# Restores backups
docker load --input ~/localops_images/ubuntu-18.04-base.tar
docker load --input ~/localops_images/ubuntu-20.04-base.tar

# Tags are lost after restoring, recreate them
docker tag ${UBUNTU_18.04_IMAGE_ID} localops:ubuntu-18.04-base
docker tag ${UBUNTU_20.04_IMAGE_ID} localops:ubuntu-20.04-base
```
_____
## Copyright & License

The following copyright notice applies to all files in localops, unless otherwise indicated in the file.

### © 2020 Guilherme Rios All Rights Reserved

All files in localops are licensed under the [MIT License](https://github.com/gasrios/localops/blob/master/LICENSE), unless otherwise indicated in the file.
