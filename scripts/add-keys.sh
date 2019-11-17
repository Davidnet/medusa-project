#!/bin/bash
# Add the keys for using balena-ssh
source /etc/bash_completion.d/balena-completion.bash
eval `ssh-agent`
ssh-add /workspace/ssh-keys/id_balena