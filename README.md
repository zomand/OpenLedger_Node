# OpenLedger Node Installer

Автоматический установщик OpenLedger Node для Ubuntu/Debian систем.

## Быстрая установка

```bash
wget -O - https://raw.githubusercontent.com/zomand/OpenLedger_Node/main/install_openledger.sh | sudo bash
```

## Ручная установка

1. Клонируем репозиторий:
```bash
git clone https://github.com/zomand/openledger_node
```

2. Переходим в директорию:
```bash
cd openledger_node
```

3. Даём права на выполнение скрипту:
```bash
chmod +x install_openledger.sh
```

4. Запускаем установку:
```bash
sudo ./install_openledger.sh
```

## Запуск ноды

После установки у вас есть два способа запуска ноды:

### 1. Автоматический запуск (рекомендуется)
```bash
start-openledger
```

### 2. Ручной запуск
```bash
tmux new -s openledger
openledger-node --no-sandbox
```

## Управление tmux сессией

- Отключиться от сессии (нода продолжит работать): `Ctrl + B`, затем `D`
- Подключиться к сессии: `tmux attach -t openledger`
- Список всех сессий: `tmux ls`
- Убить сессию: `tmux kill-session -t openledger`

## Устранение неполадок

### Ошибка X server или $DISPLAY

Если возникает ошибка "Missing X server or $DISPLAY", выполните следующие шаги:

1. Установите дополнительные пакеты:
```bash
sudo apt update
sudo apt install xfce4 xvfb
```

2. Настройте виртуальный дисплей:
```bash
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99
```

3. Создайте файл авторизации X:
```bash
touch ~/.Xauthority
```

4. Настройте SSH конфигурацию:
```bash
sudo nano /etc/ssh/sshd_config
```

Добавьте или раскомментируйте следующие строки:
```
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalHost yes
```

5. Сохраните файл (Ctrl+X, затем Y, затем Enter) и перезапустите SSH:
```bash
sudo systemctl restart sshd
```

6. Переподключитесь к tmux сессии:
```bash
tmux attach -t openledger
```
