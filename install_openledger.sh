#!/bin/bash

# Функция логирования
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Проверка root прав
if [ "$EUID" -ne 0 ]; then 
    log "Пожалуйста, запустите скрипт с правами root (sudo)"
    exit 1
fi

# Установка с выводом статуса
log "Начало установки..."

log "Установка Docker..."
{
    apt remove -y docker docker-engine docker.io containerd runc
    apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
} || { log "Ошибка при установке Docker"; exit 1; }

log "Обновление и установка зависимостей..."
{
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libsecret-1-0 unzip screen desktop-file-utils libgbm1 libasound2 xvfb
} || { log "Ошибка при установке зависимостей"; exit 1; }

log "Загрузка OpenLedger..."
{
    wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
    unzip openledger-node-1.0.0-linux.zip
} || { log "Ошибка при загрузке OpenLedger"; exit 1; }

log "Установка OpenLedger..."
dpkg -i openledger-node-1.0.0.deb || apt-get install -f -y

log "Установка завершена успешно!"
log "Для запуска используйте команды:"
log "screen -S openledger_node"
log "xvfb-run openledger-node --no-sandbox"
