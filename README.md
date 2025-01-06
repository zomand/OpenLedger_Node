# OpenLedger Node Installer

Автоматический установщик OpenLedger Node для Ubuntu/Debian систем.

## Требования
- Ubuntu/Debian-based система
- Минимум 2GB RAM
- Root доступ

## Быстрая установка

```bash
wget -O - https://raw.githubusercontent.com/zomand/OpenLedger_Node/main/install_openledger.sh | sudo bash
```

## Ручная установка

1. Установка зависимостей и обновление системы:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install ubuntu-desktop xrdp docker.io unzip screen -y
```

2. Настройка XRDP:
```bash
sudo adduser xrdp ssl-cert
sudo systemctl start gdm
sudo systemctl restart xrdp
```

3. Настройка Docker:
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

4. Установка OpenLedger:
```bash
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb
```

5. Установка дополнительных пакетов:
```bash
sudo apt update
sudo apt install -y desktop-file-utils libgbm1 libasound2
sudo dpkg --configure -a
```

## Запуск ноды

После установки запустите ноду с помощью screen:
```bash
screen -S openledger
openledger-node --no-sandbox
```

## Смена machine-id

Смена необходима если вы запустили 2 ноды, но в dashboard отображается только 1
Возникает конфликт одинаковых machine-id

## Текущий machine-id можно посмотреть командой:
```bash
cat /etc/machine-id
```

# Удалить старый machine-id
```bash
sudo rm /etc/machine-id
sudo rm /var/lib/dbus/machine-id
```
# Создать новый machine-id
```bash
sudo systemd-machine-id-setup
```
# Перезагрузить 
```bash
sudo reboot
```
# После перезагрузки запустите ноду с помощью screen:
```bash
screen -S openledger
openledger-node --no-sandbox
```

Управление screen сессией:
- Отключиться от сессии (нода продолжит работать): `Ctrl + A`, затем `D`
- Подключиться к сессии: `screen -r openledger`
- Список сессий: `screen -ls`
- Убить сессию: `screen -X -S openledger quit`

Или используйте подготовленный скрипт:
```bash
start-openledger
```

## Подключение к ноде

1. Windows:
   - Подключитесь через Remote Desktop Connection (RDP)
   - Хост: IP-адрес вашего сервера
   - Логин/пароль: ваши учетные данные Ubuntu

2. Mac:
   - Установите клиент Microsoft Remote Desktop
   - Добавьте новое подключение с IP-адресом сервера
   - Используйте учетные данные Ubuntu

## Обновления

Для обновления ноды:
```bash
wget https://cdn.openledger.xyz/openledger-node-latest.zip
unzip openledger-node-latest.zip
sudo dpkg -i openledger-node*.deb
```

## Устранение неполадок

### Ошибка доступа к Docker
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Проблемы с XRDP
```bash
sudo systemctl restart xrdp
```

### Ошибки установки пакетов
```bash
sudo apt --fix-broken install
sudo dpkg --configure -a
```

### Проблемы со screen сессией
```bash
# Восстановить потерянную сессию
screen -d -r openledger

# Если screen не установлен
sudo apt install screen
```

## Безопасность

- Используйте сложные пароли
- Настройте файрвол
- Регулярно обновляйте систему

## Поддержка

При возникновении проблем создайте issue в репозитории.

## Лицензия

MIT
