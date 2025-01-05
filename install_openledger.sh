#!/bin/bash

# Проверка на root права
if [ "$EUID" -ne 0 ]; then 
  echo "Пожалуйста, запустите скрипт с правами root (sudo)"
  exit
fi

# Установка Docker
echo "Установка Docker..."
apt remove -y docker docker-engine docker.io containerd runc
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Обновление и установка зависимостей
echo "Установка зависимостей..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io
apt install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0
apt install -y unzip screen desktop-file-utils libgbm1 libasound2 xvfb

# Загрузка и установка OpenLedger
echo "Загрузка и установка OpenLedger..."
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
dpkg -i openledger-node-1.0.0.deb || true
apt-get install -f -y

# Настройка и запуск
echo "Настройка завершена."
echo "Для запуска ноды используйте команды:"
echo "screen -S openledger_node"
echo "xvfb-run openledger-node --no-sandbox"
