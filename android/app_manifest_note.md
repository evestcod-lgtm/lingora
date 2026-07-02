# Важно про Android-манифест

Полный каталог `android/` (со всеми gradle-файлами, `AndroidManifest.xml`, иконками
и т.д.) генерируется автоматически командой `flutter create .`, которую нужно
выполнить один раз внутри папки проекта (см. README.md, шаг 1).

После генерации добавь в `android/app/src/main/AndroidManifest.xml`
разрешение на вибрацию (нужно для тактильного отклика в приложении),
внутри тега `<manifest>`, перед `<application>`:

```xml
<uses-permission android:name="android.permission.VIBRATE"/>
```

Больше никаких особых прав приложению не требуется — оно полностью офлайн.
