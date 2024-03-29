# localops

Local environment software installation and configuration tool that uses [Ansible](https://www.ansible.com/).

You may be interested in this project if:

1. You constantly need to set up computers for your own use, with different configurations each time (my personal motivation);
1. You manage several distinct computer configurations, and are just plain tired of doing so manually, having to remember every little detail and difference each one has (come to think of it, my personal motivation, too).

## Currently supported distros:

* [Ubuntu 18.04 (Bionic Beaver)](http://releases.ubuntu.com/18.04/), 64 bit only
* [Ubuntu 20.04 (Focal Fossa)](http://releases.ubuntu.com/20.04/)

If you would like to add support to your favorite distro, check [bootstrap.sh](https://github.com/gasrios/localops/blob/master/bootstrap.sh#L8) out. Some playbooks assume Ubuntu, others should work with any distro out of the box, but the installation can be easily customized to support any other you want.

## Installation

**Note:** Unless you know me personally, or work with me, you should not execute any instructions in this section before double checking them and the contents of script [bootstrap.sh](https://github.com/gasrios/localops/blob/master/bootstrap.sh). For all you know, I may not even exist, and this project is a trojan someone created to install a rootkit in your computer.

After you are satisfied verifying everything, run the following command, first for a user than can `sudo`, or root, then for each user you want to be able to use localops:

```
curl -s https://raw.githubusercontent.com/gasrios/localops/master/bootstrap.sh | bash -
```

If asked, inform your password.

## Using localops

After installation, you can install additional softwares from the command line by running the following command:

`localops ${PATH_TO_PLAYBOOK}`

A list of useful playbooks can be found at [localops-playbooks](https://github.com/gasrios/localops-playbooks).
_____
## Copyright & License

The following copyright notice applies to all files, unless otherwise indicated in the file.

### © 2021 Guilherme Rios All Rights Reserved

All files in localops are licensed under the [MIT License](https://github.com/gasrios/localops/blob/master/LICENSE), unless otherwise indicated in the file.
