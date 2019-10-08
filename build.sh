#!/bin/bash
path=$(pwd)

core_module=mission-control-core-ui

modules=(
	mission-control-allofus-ui
	mission-control-capacitymgmt-ui
	mission-control-reporting-ui
	mission-control-scheduler-ui
	mission-control-support-tool-ui
	smp-communications-ui
	smp-hos-ui
)

deployed_folders=(
	com.vibrenthealth.missioncontrol.allofus
	com.vibrenthealth.missioncontrol.capacity
	com.vibrenthealth.missioncontrol.report
	com.vibrenthealth.missioncontrol.scheduler
	com.vibrenthealth.missioncontrol.supporttool
	com.vibrenthealth.smp.communications
	com.vibrenthealth.smp.hos
)
# npm install core ui
cd $path/$core_module/
if [ ! -d node_modules ]; then
 echo -e "\e[1;32mCore UI\e[0m"
 echo -e "\e[1;32mnpm install...\e[0m"
 npm install
fi

cd $path/$core_module/public/
[ -d modules ] || mkdir modules && cd modules
# make deployed folder name
for (( i=0; i<${#deployed_folders[@]}; i++ ))
 do
  [ -d ${deployed_folders[$i]} ] || mkdir ${deployed_folders[$i]}
 done

for (( position=1; position<=${#modules[@]}; position++ ))
 do
   echo -e "\e[1;32m[$position]\e[0m -> [${modules[$[position - 1]]}]"
 done

# build a module and copy to core
# $1 -> parent path
# $2 -> local module folder
# $3 -> deployed folder name
build_module(){
  echo -e "\e[1;32mBuilding [$1] module\e[0m"
  cd $path/$1
  echo -e "\e[1;32mnpm install...\e[0m"
  npm install
  npm run build
  rm -rf $path/$core_module/public/modules/$2/static
  cd build
  cp -rf static $path/$core_module/public/modules/$2/
  echo -e "\e[1;32mDone $2\e[0m"
  exit 1
}

read num
build_module ${modules[$[num - 1]]} ${deployed_folders[$[num - 1]]}
