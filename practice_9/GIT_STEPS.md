# Порядок сдачи

```bash
flutter create shop && cd shop
flutter pub add provider

# 1) Level 1: скопируй level1_lifted/lib/* в lib/ (без папки models), запусти
flutter run
git init && git add . && git commit -m "lifted"

# 2) Final: удали старые lib/*.dart и скопируй lib/ из этого архива целиком
rm -rf lib && cp -r <архив>/lib ./lib
dart format .
flutter analyze            # No issues found!
flutter run                # сделай screenshot_books.png и screenshot_cart.png
git add . && git commit -m "provider"
git remote add origin <repo> && git push -u origin main
```

Не забудь положить NOTES.md (с реальными числами) и оба скриншота в корень репозитория.
