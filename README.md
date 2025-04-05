# localops

Local environment software installation and configuration tool that uses [Ansible](https://www.ansible.com/).

Think of it as "documentation as code." I got tired of always having to look for and read the same pages online, then run manually exactly the same steps, every time I wanted to do something more complex than install a distro provided package. Turning this documentation into code I can execute instead is simpler.

## Supported distros:

* [Debian 12 (bookworm)](https://www.debian.org/releases/bookworm/)
* [Ubuntu 22.04 (Jammy Jellyfish)](http://releases.ubuntu.com/22.04/)
* [Ubuntu 24.04 (Noble Numbat)](http://releases.ubuntu.com/22.04/)

If you would like to add support to your favorite distro, check [bootstrap.sh](https://github.com/gasrios/localops/blob/master/bootstrap.sh#L80) out.

## Installation

**Note:** Unless you know me personally, or work with me, you should not execute any instructions in this section before double checking them and the contents of script [bootstrap.sh](https://github.com/gasrios/localops/blob/master/bootstrap.sh). For all you know, I may not even exist, and this project is a trojan someone created to install a rootkit on your computer.

After you are satisfied verifying everything, run the following command, first for a user than can `sudo`, or root, then for each user you want to be able to use localops:

```
curl -s https://raw.githubusercontent.com/gasrios/localops/master/bootstrap.sh | sh -
```

If asked, inform your password.

## Using localops

After installation, you can install additional software from the command line by running the following command:

`localops ${PATH_TO_PLAYBOOK}`

A list of useful playbooks can be found at [localops-playbooks](https://github.com/gasrios/localops-playbooks).
_____
## Copyright & License

The following copyright notice applies to all files, unless otherwise indicated in the file.

### © 2025 Guilherme Rios All Rights Reserved

All files in localops are licensed under the [MIT License](https://github.com/gasrios/localops/blob/master/LICENSE), unless otherwise indicated in the file.
