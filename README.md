# OpenLedger Node Installer

Автоматический установщик OpenLedger Node для Ubuntu/Debian систем.

## Установка

```bash
# Клонируем репозиторий
git clone https://github.com/zomand/openledger_node

# Переходим в директорию
cd openledger-installer

# Даём права на выполнение скрипту
chmod +x install_openledger.sh

# Запускаем установку
sudo ./install_openledger.sh

# Запуск ноды
После установки запустите ноду командами:
bashCopyscreen -S openledger_node
xvfb-run openledger-node --no-sandbox

# Для выхода из screen сессии: Ctrl+A, затем D
# Для возврата в сессию: screen -r openledger_node

# Быстрая установка

wget -O - https://raw.githubusercontent.com/zomand/OpenLedger_Node/main/install_openledger.sh | sudo bash
