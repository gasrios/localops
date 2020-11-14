#!/bin/bash
set -euxo pipefail

echo y | ufw reset

ufw logging high

ufw default deny incoming
ufw default allow outgoing
ufw default deny routed

ufw allow in on cni0
ufw allow out on cni0

ufw enable
