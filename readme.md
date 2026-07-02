# Lingora 🌟

Игровое приложение для изучения языков мира Lingora: Дюсковый, Гладный, Чаечный.
Гномик-помощник, уроки, словарь, достижения, streak-система, настройки.

Это **чистый исходник Flutter-проекта** (папки `lib/`, `pubspec.yaml`, `assets/`).
Технических файлов `android/`, `ios/` тут нет — их сгенерирует сама команда
`flutter create .` на первом шаге сборки (это стандартная практика, они зависят
от версии Flutter/Gradle на твоей машине и их не стоит носить с собой вручную).

---

## Способ 1. GitHub Actions (рекомендуется — не нужен Android SDK на телефоне)

1. Создай новый репозиторий на GitHub, залей туда все файлы этого проекта
   (`lib/`, `pubspec.yaml`, `assets/`, `README.md`).
2. Добавь в репозиторий файл `.gitignore` со строками:
   ```
   build/
   .dart_tool/
   android/
   ios/
   ```
3. Создай файл `.github/workflows/build.yml`:

```yaml
name: Build APK
on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
      - name: Generate Android project
        run: flutter create --platforms=android .
      - name: Get packages
        run: flutter pub get
      - name: Build APK
        run: flutter build apk --release
      - uses: actions/upload-artifact@v4
        with:
          name: lingora-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

4. Запушь изменения (`git push`). Открой вкладку **Actions** в репозитории —
   сборка стартует автоматически.
5. Через 3–6 минут в разделе **Actions → (последний run) → Artifacts** появится
   `lingora-apk` — скачай его на телефон и установи (разреши установку из
   неизвестных источников в настройках Android).

Это самый надёжный способ — сборка идёт на серверах GitHub, ничего настраивать
на телефоне не нужно.

---

## Способ 2. Прямо на телефоне через Termux

Тяжелее (сборка Android через Gradle требует много ресурсов), но реально:

```bash
pkg update && pkg upgrade
pkg install git wget unzip openjdk-17

# Установка Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:~/flutter/bin"
flutter doctor

# Перенеси проект Lingora в Termux (например через git clone своего репозитория)
cd ~/lingora
flutter create --platforms=android .
flutter pub get
flutter build apk --release
```

APK появится в `build/app/outputs/flutter-apk/app-release.apk`.
Учитывай: полная сборка Android через Gradle в Termux может занимать
20–40+ минут и требует стабильного интернета (Gradle скачивает зависимости)
и достаточно свободной памяти на телефоне (от 4 ГБ желательно).
Если сборка падает по памяти — способ 1 (GitHub Actions) намного стабильнее.

---

## Способ 3. Обычный компьютер + Android Studio / VS Code

1. Установи [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. `flutter create --platforms=android .` в папке проекта.
3. `flutter pub get`
4. `flutter build apk --release` — либо просто `flutter run` при подключённом
   по USB телефоне (с включённой отладкой по USB) для мгновенного запуска.

---

## Что нужно доделать перед первым запуском

1. **Звуки.** В `assets/sounds/` сейчас нет реальных mp3-файлов (только
   `README.txt` с описанием, какие нужны: `click.mp3`, `success.mp3`,
   `error.mp3`, `reward.mp3`, `gnome_happy.mp3`, `gnome_sad.mp3`,
   `gnome_beg.mp3`, `streak.mp3`). Без них приложение **не упадёт** —
   `SoundService` перехватывает ошибку и молча работает без звука — но для
   полного эффекта добавь короткие (0.2–1 сек) бесплатные звуки, например
   с mixkit.co/free-sound-effects или freesound.org.
2. **Разрешение на вибрацию** — см. `android/app_manifest_note.md`
   (добавляется автоматически при первой генерации, вручную нужно только
   дописать одну строку в манифест).
3. **Иконка приложения** — по умолчанию будет стандартная Flutter-иконка.
   Для кастомной иконки удобно использовать пакет `flutter_launcher_icons`.

---

## Структура проекта

```
lib/
  main.dart                     — точка входа, глобальное состояние (AppState), сплеш
  theme/app_theme.dart          — цвета, градиенты, типографика
  models.dart                   — все модели данных
  data/languages_data.dart      — словари и фразы 3 языков + достижения
  services/services.dart        — хранение, прогресс/streak, звук, настроение гномика,
                                   генератор упражнений
  widgets/widgets.dart          — GradientBackground, GlassCard, PrimaryButton,
                                   GnomeWidget, ProgressRing, RewardBurst, анимации
  screens/
    onboarding_screens.dart     — приветствие → уровень → минуты в день → язык
    home_screen.dart            — главный экран + нижняя навигация
    lesson_screen.dart          — движок упражнений (выбор варианта, сборка фразы) + результат
    dictionary_screen.dart      — словарь и фразы
    progress_screen.dart        — статистика, streak, XP, уровень
    achievements_screen.dart    — достижения
    settings_screen.dart        — все настройки
    profile_screen.dart         — профиль пользователя
    reminders_screen.dart       — настройка напоминаний
    gnome_screen.dart           — отдельный экран с гномиком
```

## Что уже проверено

- Все экраны из ТЗ реализованы и связаны навигацией (онбординг → дом →
  урок/словарь/прогресс/достижения/настройки/профиль/напоминания/гномик).
- Импорты во всех файлах перепроверены вручную — нет битых путей.
- Найден и исправлен потенциальный бесконечный цикл в формуле левелапа
  (`ProgressService.addXp`).
- Найдена и убрана неиспользуемая переменная в сборщике предложений.
- Прогресс, настройки, имя пользователя и статус онбординга сохраняются
  через `shared_preferences` и переживают перезапуск приложения.
- Тексты интерфейса не содержат фраз вроде "выдуманный язык" — везде
  подаётся как часть мира Lingora.
- `SoundService` и `Vibration` обёрнуты в try/catch — отсутствие звуковых
  файлов или вибромотора не приводит к падению приложения.

## Известные ограничения

- Реальные аудиофайлы не включены (см. пункт 1 выше) — добавь свои для
  полного звукового опыта.
- APK не собран физически в этой среде (нет Android SDK/интернета в
  песочнице) — собери одним из трёх способов выше, это займёт от 3 минут
  (GitHub Actions) до ~40 минут (Termux).
- Иконка приложения — стандартная, пока не заменена кастомной.
- Уведомления-напоминания пока хранятся как настройка (время/переключатель),
  но не запускают системные push-уведомления — для этого нужно добавить
  `flutter_local_notifications` и настроить платформенные разрешения; экран
  и логика выбора времени уже готовы, чтобы это подключить.

