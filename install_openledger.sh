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

# Настройка X11 и SSH
log "Настройка X11 и SSH..."
{
   # Создание .Xauthority
   touch ~/.Xauthority
   
   # Конфигурация SSH для X11 Forwarding
   cat >> /etc/ssh/sshd_config << 'EOF'
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalHost yes
EOF
   
   # Перезапуск SSH
   systemctl restart sshd
   
   # Настройка виртуального дисплея
   export DISPLAY=:99
   Xvfb :99 -screen 0 1920x1080x24 &
} || { log "Ошибка при настройке X11 и SSH"; exit 1; }

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
   apt install -y docker-ce docker-ce-cli containerd.io \
   libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils \
   libatspi2.0-0 libsecret-1-0 unzip tmux desktop-file-utils \
   libgbm1 libasound2 xvfb mesa-utils libgl1-mesa-glx \
   libgl1-mesa-dri xserver-xorg-video-all libegl1-mesa \
   libegl1-mesa-dev libgles2-mesa-dev xfce4
} || { log "Ошибка при установке зависимостей"; exit 1; }

log "Загрузка OpenLedger..."
{
   wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
   unzip openledger-node-1.0.0-linux.zip
} || { log "Ошибка при загрузке OpenLedger"; exit 1; }

log "Установка OpenLedger..."
dpkg -i openledger-node-1.0.0.deb || apt-get install -f -y

# Создание скрипта запуска
log "Создание скрипта запуска..."
cat > /usr/local/bin/start-openledger << 'EOF'
#!/bin/bash

# Проверка и настройка окружения
if ! pgrep Xvfb > /dev/null; then
   export DISPLAY=:99
   Xvfb :99 -screen 0 1920x1080x24 &
fi

if ! command -v tmux &> /dev/null; then
   echo "Установка tmux..."
   sudo apt update
   sudo apt install -y tmux
fi

if tmux has-session -t openledger 2>/dev/null; then
   echo "Сессия openledger уже существует. Подключение..."
   tmux attach -t openledger
else
   echo "Создание новой сессии openledger..."
   tmux new-session -d -s openledger 'openledger-node --no-sandbox'
   echo "Сессия создана. Подключение..."
   tmux attach -t openledger
fi
EOF

chmod +x /usr/local/bin/start-openledger

log "Установка завершена успешно!"
log "Для запуска ноды используйте команду:"
log "start-openledger"
log ""
log "Управление tmux сессией:"
log "- Отключиться от сессии (нода продолжит работать): Ctrl + B, затем D"
log "- Подключиться к сессии: tmux attach -t openledger"
log "- Список всех сессий: tmux ls"
log "- Убить сессию: tmux kill-session -t openledger"
