# localops

[Ansible playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) to manage installation and configuration of local environments.

You may be interested in this project if:

1. You constantly need to set up computers for your own use, with different configurations each time (my personal motivation);
1. You manage several distinct computer configurations, and are just plain tired of doing so manually, having to remember every little detail and difference each one has (come to think of it, my personal motivation, too).

The existing playbooks suit my particular needs and may, or may not, interest you. Some perform very basic tasks, like installing Google Chrome or LibreOffice; others will go as far as installing Jenkins and Nginx, configuring the latter to proxy the former using HTTPS. One usually does not need to run such services locally, I do so to test and develop CI/CD pipelines and the like, hopefully someone else may benefit from them.

## Currently supported distros:

* [Ubuntu 18.04 (Bionic Beaver)](http://releases.ubuntu.com/18.04/), 64 bit only
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

## Security

Playbooks are split into three categories:

* [root](https://github.com/gasrios/localops/tree/master/root): playbooks that run as root and make system wide changes.
* [user](https://github.com/gasrios/localops/tree/master/user): playbooks that need no special permissions and make changes only to the environment local to the user running them.
* [other](https://github.com/gasrios/localops): "meta playbooks" that invoke both root and user playbooks.

This separation supports use cases in which separation of responsibilities is necessary, because your non root user has no sudo permissions, and those more common, and less secure, situations when your regular user can sudo.

## Currently Available Playbooks

* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* Local [certificate authority](https://en.wikipedia.org/wiki/Certificate_authority)
* [Chef Workstation](https://docs.chef.io/workstation/)
* [Codacy Analysis CLI](https://github.com/codacy/codacy-analysis-cli)
* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker local registry](https://docs.docker.com/registry/insecure/) as [systemctl](https://www.freedesktop.org/software/systemd/man/systemctl.html) service
* [Dropbox](https://www.dropbox.com/)
* [GitHub CLI](https://cli.github.com/)
* [Google Chrome](https://www.google.com/chrome)
* [Google Cloud SDK](https://cloud.google.com/sdk)
* [Helm](https://helm.sh/)
* [IntelliJ](https://www.jetbrains.com/idea/)
* [Java](https://openjdk.java.net/)
* [Jenkins](https://jenkins.io/)
* [Jupyter](https://jupyter.org/)
* [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/)  **(see note 1 below!)**
* [kubectl CLI](https://kubernetes.io/docs/reference/kubectl/)
* [Kubeval](https://www.kubeval.com/)
* [LibreOffice](https://www.libreoffice.org/)
* [LocalStack](https://localstack.cloud/)
* [MicroK8s](https://microk8s.io/) **(see note 2 below!)** and [Kubeval](https://github.com/instrumenta/kubeval)
* [NFS Server](https://tools.ietf.org/html/rfc5661)
* [Nginx](https://nginx.org/en/)
* [Node.js](https://nodejs.org/en/)
* [Packer](https://packer.io/) by Hashicorp
* [Salesforce](https://www.salesforce.com/)
* [Slack](https://slack.com/)
* [Spotify for Linux](https://www.spotify.com/br/download/linux/)
* [Spring Boot CLI](https://javasterling.com/spring-boot/spring-boot-cli)
* [Terraform](https://www.terraform.io/) by Hashicorp
* [Visual Studio Code](https://code.visualstudio.com/)

Some of the above do nothing beyond installing packages from official Ubuntu repositories, which may seem to be overkill. Still, having a playbook might be useful, as it can be imported by other playbook to orchestrate installation of complex environments, and/or add additional configuration to them.

1. MicroK8s [can't reach the internet](https://microk8s.io/docs/troubleshooting#heading--common-issues). If you need your microk8s cluster to access the Internet, localops provides script [microk8s/ufw-allow-microk8s.sh](https://github.com/gasrios/localops/blob/master/microk8s/ufw-allow-microk8s.sh) to help you configure your firewall. However, localops **DOES NOT** execute it, as this might be a security issue. Please review and customize it as you see fit, given your use cases. Even after correctly configuring your firewall, you may experience connectivity issues, after rebooting. Running "microk8s stop" before shutting down should prevent them from happening and, even if they do, "microk8s stop" and "microk8s start" should fix them.
1. JupyterHub's playbook will install it on the cluster being referred to by your environment variables KUBECONFIG and CONTEXT, which may or may not be local to your computer. If you install MicroK8s using localops, JupyterHub will be installed in it by default.

## Testing

* [test/setup.sh](https://github.com/gasrios/localops/blob/master/test/setup.sh) creates "test" Docker images. "Vanilla" Ubuntu Docker images do not have all the packages you would expect to find in an Ubuntu desktop, so we add the bare minimum that ensure compatibility.

* [test/test.sh](https://github.com/gasrios/localops/blob/master/test/test.sh) runs the installation process in all supported environments.
_____
## Copyright & License

The following copyright notice applies to all files in localops, unless otherwise indicated in the file.

### © 2021 Guilherme Rios All Rights Reserved

All files in localops are licensed under the [MIT License](https://github.com/gasrios/localops/blob/master/LICENSE), unless otherwise indicated in the file.
