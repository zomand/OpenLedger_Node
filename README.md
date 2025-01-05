# OpenLedger Node Installer

Автоматический установщик OpenLedger Node для Ubuntu/Debian систем с поддержкой GUI через X11.

## Требования

- Ubuntu/Debian-based система
- Доступ к root правам
- Минимум 2GB RAM
- Стабильное интернет-соединение

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
Этот способ автоматически настраивает виртуальный дисплей и запускает ноду в tmux сессии.

### 2. Ручной запуск
```bash
tmux new -s openledger
xvfb-run openledger-node --no-sandbox
```

## Управление tmux сессией

- Отключиться от сессии (нода продолжит работать): `Ctrl + B`, затем `D`
- Подключиться к сессии: `tmux attach -t openledger`
- Список всех сессий: `tmux ls`
- Убить сессию: `tmux kill-session -t openledger`

## Особенности установки

- Автоматическая настройка X11 forwarding
- Установка и настройка виртуального дисплея (Xvfb)
- Настройка SSH для поддержки GUI
- Создание удобного скрипта запуска

## Устранение неполадок

### Ошибка X server или $DISPLAY

Если возникает ошибка "Missing X server or $DISPLAY", выполните следующие шаги:

1. Проверьте статус виртуального дисплея:
```bash
ps aux | grep Xvfb
```

2. Если виртуальный дисплей не запущен:
```bash
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99
```

3. Перезапустите ноду:
```bash
start-openledger
```

### Проблемы с GUI

Если возникают проблемы с графическим интерфейсом:

1. Проверьте конфигурацию SSH:
```bash
sudo nano /etc/ssh/sshd_config
```

Убедитесь, что присутствуют строки:
```
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalHost yes
```

2. Перезапустите SSH сервис:
```bash
sudo systemctl restart sshd
```

### Очистка и перезапуск

Если нужно полностью перезапустить ноду:

1. Убить все сессии tmux:
```bash
tmux kill-server
```

2. Остановить виртуальный дисплей:
```bash
pkill Xvfb
```

3. Создать файл авторизации X:
```bash
touch ~/.Xauthority
```

4. Запустить заново:
```bash
start-openledger
```

## Безопасность

- Все соединения через SSH туннель шифруются
- Виртуальный дисплей изолирован от основной системы
- Процессы запускаются в изолированных tmux сессиях

## Обновление

Если вышла новая версия скрипта:

1. Остановить текущую ноду:
```bash
tmux kill-session -t openledger
pkill Xvfb
```

2. Обновить репозиторий:
```bash
cd openledger_node
git pull
```

3. Перезапустить установку:
```bash
sudo ./install_openledger.sh
```

## Вклад в развитие

Если у вас есть предложения по улучшению установщика или вы нашли ошибку, пожалуйста, создайте issue или pull request в этом репозитории.

## Лицензия

MIT
