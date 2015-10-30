#!/bin/bash

set -o nounset -o errexit -o pipefail -o errtrace

TOOL_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$TOOL_SOURCE" ] ; do TOOL_SOURCE="$(readlink "$TOOL_SOURCE")"; done
provision_bin_dir="$( cd -P "$( dirname "$TOOL_SOURCE" )" && pwd )"
chmod -R +x "$provision_bin_dir"
provision_base="$( cd -P "$( dirname "$provision_bin_dir" )" && pwd )"
provision_files_dir="${provision_base}/files"

OPTS=`getopt -n $0 -o b:p:u: --long basedir:,proxy:,user: -- $@`
ret=$?

if [ $ret -ne 0 ]; then
    echo "ERROR: unrecognized / wrong option";
    exit 1
fi

eval set -- "$OPTS"

bootstrap_user='vagrant'
bootstrap_proxy=''
bootstrap_basedir="$HOME"
bootstrap_args=''

while true
do
  case "$1" in
    -p|--proxy)
        bootstrap_proxy="${2}"
        shift 2 ;;
    -b|--basedir)
        bootstrap_basedir="${2}"
        shift 2 ;;
    -u|--user)
        bootstrap_user="${2}"
        shift 2 ;;
    --)
        shift; break;;
  esac
done
bootstrap_args="${@}"

# This script will be ran using user root.
echo "Running ${0} as:"
whoami
id
echo ''
sudo -u "$bootstrap_user" /bin/bash -c "whoami"
sudo -u "$bootstrap_user" /bin/bash -c "echo $USER $HOME"
echo "bootstrap"
echo "- user    : ${bootstrap_user}"
echo "- proxy   : ${bootstrap_proxy}"
echo "- basedir : ${bootstrap_basedir}"
echo "- args    : ${bootstrap_args}"

# Export proxy for usage in other scripts
if [ ! -z "$bootstrap_proxy" ]; then
    export HTTP_PROXY="$bootstrap_proxy"
    export HTTPS_PROXY="$bootstrap_proxy"
    export http_proxy="$bootstrap_proxy"
    export https_proxy="$bootstrap_proxy"
fi

# install ansible only if needed
#hash ansible 2>/dev/null || {
    # ubuntu trusty
    # apt-get -y -q update
    # apt-get install -y -q python-software-properties software-properties-common apt-transport-https
    # apt-add-repository ppa:ansible/ansible
    # apt-get -y -q update
    # apt-get install -y -q ansible
    # debian jessie
    #apt-get install -y -q python-pip libxml2-dev python-dev sshpass
    #pip install markupsafe jinja2 ansible
#}
ansible --version

mkdir -p /etc/ansible
[[ -f /etc/ansible/hosts ]] && {
  mv /etc/ansible/hosts /etc/ansible/hosts.ORIG
}
echo '[dockerhost]
127.0.0.1' > /etc/ansible/hosts

echo ansible-playbook --connection local \
  --extra-vars "basedir=${bootstrap_basedir} user=${bootstrap_user}" \
  -s "${bootstrap_basedir}/provision/site.yml"

ansible-playbook --connection local \
  --extra-vars "basedir=${bootstrap_basedir} user=${bootstrap_user}" \
  -s "${bootstrap_basedir}/provision/site.yml"

exit 0
