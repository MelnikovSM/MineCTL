#!/bin/bash

echo "Minecraft Server management script by MelnikovSM"

if [ -a ~/.minectl ]; then

source ~/.minectl

echo "[MineCtl] Config file (~/.minectl) is detected and loaded."

else


#######################################

#This is config of script


#It could be loaded from ~/.minectl


#Path to your Minecraft server dir (ex. ~/server)


SERVER_DIR=~/server


#Minimal RAM Usage (ex. 256M = 256 Megabytes, 1G = 1 Gigabyte)


MIN_RAM=256M


#Maximal RAM Usage (ex. 256M = 256 Megabytes, 1G = 1 Gigabyte)


MAX_RAM=1G


#Server port (ex. 25565)


SERVER_PORT=25565

#######################################


fi



#Here is code

PID=`lsof -i -P | grep ":$SERVER_PORT (LISTEN)" | awk '{print $2}'`

if [ "$1" ]; then


  if [ "$1" == "start" ]; then

  

    if [ "$PID" != "" ]; then

      echo "[MineCtl] Minecraft Server already running with PID $PID"

      else

      echo "[MineCtl] Starting up Minecraft Server.."

      cd $SERVER_DIR

      tmux new -d -s minesrv "java -Xincgc -Xmx$MAX_RAM -Xms$MIN_RAM -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalPacing -XX:ParallelGCThreads=4 -XX:+AggressiveOpts -Dfile.encoding=UTF-8 -jar *.jar"
      echo 'Running in background, type "tmux attach -t minesrv" to open console'

    fi


  fi


  if [ "$1" == "status" ]; then

	if [ "$PID" != "" ]; then

	  echo "[MineCtl] Minecraft Server is running with PID $PID"

	else

	  echo "[MineCtl] Minecraft Server not running"

	fi

  fi



  if [ "$1" == "stop" ]; then

	if [ "$PID" != "" ]; then

  	echo "[MineCtl] Killing Minecraft Server with PID $PID"

  	kill -9 $PID

	else

	  echo "[MineCtl] Minecraft Server not running"

	fi

  fi



  if [ "$1" == "--help" ]; then

  echo "Warning! You must configure your server launch options before start it."

  echo "a) Type nano [path]/minectl and edit parameters. (starts at 8 line)"

  echo "b) Type minectl configure"

  echo "MineCtl Usage:"

  echo "start - start your server"

  echo "status - get status of your server"

  echo "stop - stop your server"

  echo "--help - this page"

  echo "configure - generate config file"

  echo "info - current config information"

  fi


  if [ "$1" == "configure" ]; then

  echo "Configuring MineCtl.."

  if [ -a ~/.minectl ]; then

  rm ~/.minectl

  fi

  read -p "Enter path to your server dir (ex. ~/server): " n

  echo "SERVER_DIR=$n" >> ~/.minectl

  read -p "Minimal server RAM (ex. 256M or 1G): " n

  echo "MIN_RAM=$n" >> ~/.minectl

  read -p "Maximal server RAM (ex. 256M or 1G): " n

  echo "MAX_RAM=$n" >> ~/.minectl

  read -p "Enter server port (defined in server.properties must match): " n

  echo "SERVER_PORT=$n" >> ~/.minectl

  fi


  if [ "$1" == "info" ]; then

  echo "Current config info:"

  if [ -a ~/.minectl ]; then

  echo "Config source: local config (~/.minectl)"

  else echo "Config source: defaults"

  fi

  echo "Server dir: "$SERVER_DIR

  echo "Minimal RAM: "$MIN_RAM

  echo "Maximal RAM: "$MAX_RAM

  echo "Server port: "$SERVER_PORT

  fi




else

  echo "Usage: minectl [start|stop|status]"

  echo "Type: minectl --help for more help"

fi
