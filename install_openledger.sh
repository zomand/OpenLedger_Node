#!/bin/bash

# Обновление системы и установка необходимых пакетов
sudo apt update && sudo apt upgrade -y
sudo apt install ubuntu-desktop xrdp docker.io unzip -y

# Настройка XRDP
sudo adduser xrdp ssl-cert
sudo systemctl start gdm
sudo systemctl restart xrdp

# Настройка Docker
sudo systemctl start docker
sudo systemctl enable docker

# Загрузка и установка OpenLedger
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb

# Установка зависимостей
sudo apt update
sudo apt install -y desktop-file-utils libgbm1 libasound2
sudo dpkg --configure -a

# Создание скрипта запуска
cat > /usr/local/bin/start-openledger << 'EOF'
#!/bin/bash
openledger-node --no-sandbox
EOF

chmod +x /usr/local/bin/start-openledger

echo "Установка завершена. Запустите ноду командой: start-openledger"
