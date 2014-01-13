#!/bin/bash

#your project name in hg
repo_name="hearthstone"
www_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"
echo "Deploy project $repo_name to $www_dir"

hg_login=wangjinyi:123123
hg_key=108487b862b31f3a8d363cfd0e213c42d3200109
hg_url=hg.stm.com/$repo_name
hg_http_header="HOST: hg.stm.com"

if [ $# -eq 0 ]
then
  rev=tip
else
  rev=$1
fi

tip=`wget -q -O- --header="$hg_http_header" --header="Accept: application/mercurial-0.1" "http://$hg_login@$hg_url?cmd=lookup&key=$rev" | awk '{print substr($2,1,12)}'`
echo Getting revision $rev:$tip from hg repository...
wget -q --header="$hg_http_header" -O - "http://$hg_login@$hg_url/archive/$tip.tar.gz?api_key=$hg_key" | tar --overwrite --strip-components=1 -C $www_dir -zmxf -
echo `date --rfc-3339=s`,$tip,$SSH_CONNECTION >> ${BASH_SOURCE[0]%.*}.log

