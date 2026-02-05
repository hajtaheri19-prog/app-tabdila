# راهنمای ساخت آیکون اپلیکیشن

## آیکون اصلی

آیکون اپلیکیشن «تبدیلا» باید یک دایره بنفش باشد.

### مشخصات طراحی

- **شکل**: دایره کامل
- **رنگ اصلی**: بنفش (#9C27B0)
- **اندازه اصلی**: 512x512 پیکسل
- **فرمت**: PNG با پس‌زمینه شفاف

### ساخت آیکون‌های مختلف

برای ساخت آیکون‌های مختلف برای Android، از ابزارهای زیر استفاده کنید:

1. **Android Asset Studio** (آنلاین):
   - به [این لینک](https://romannurik.github.io/AndroidAssetStudio/icons-launcher.html) بروید
   - آیکون 512x512 خود را آپلود کنید
   - آیکون‌های مختلف را دانلود کنید

2. **Flutter Launcher Icons** (پکیج):
   ```bash
   flutter pub add --dev flutter_launcher_icons
   ```
   
   سپس در `pubspec.yaml` اضافه کنید:
   ```yaml
   flutter_launcher_icons:
     android: true
     image_path: "assets/images/icon.png"
   ```
   
   و اجرا کنید:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

### اندازه‌های مورد نیاز

- **mdpi**: 48x48
- **hdpi**: 72x72
- **xhdpi**: 96x96
- **xxhdpi**: 144x144
- **xxxhdpi**: 192x192

### محل قرارگیری

آیکون‌ها باید در مسیرهای زیر قرار گیرند:
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

