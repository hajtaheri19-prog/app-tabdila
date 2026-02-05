# راهنمای راه‌اندازی پروژه تبدیلا

## مراحل نصب

### 1. نصب Flutter

اگر Flutter نصب نشده است، از [این لینک](https://flutter.dev/docs/get-started/install) آن را نصب کنید.

### 2. بررسی نصب

```bash
flutter doctor
```

### 3. نصب وابستگی‌ها

```bash
flutter pub get
```

### 4. اضافه کردن فونت‌های فارسی

1. از [مخزن Vazir Font](https://github.com/rastikerdar/vazir-font) فونت را دانلود کنید
2. فایل‌های زیر را استخراج کنید:
   - `Vazir-Regular.ttf`
   - `Vazir-Bold.ttf`
   - `Vazir-Medium.ttf`
   - `Vazir-Light.ttf`
3. این فایل‌ها را در پوشه `assets/fonts/` قرار دهید

### 5. ساخت دایرکتوری‌های مورد نیاز

```bash
mkdir -p assets/fonts
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
```

### 6. اجرای اپلیکیشن

برای اجرا روی دستگاه یا شبیه‌ساز:

```bash
flutter run
```

## ساخت APK

برای ساخت فایل APK قابل نصب:

```bash
flutter build apk --release
```

## ساخت AAB (برای Google Play)

```bash
flutter build appbundle --release
```

## نکات مهم

- حداقل SDK: Android 5.0 (API 21)
- Target SDK: Android 14 (API 34)
- زبان اصلی: فارسی (Farsi/Persian)
- پشتیبانی از RTL: بله

## عیب‌یابی

### مشکل فونت‌ها

اگر فونت‌ها نمایش داده نمی‌شوند:
1. مطمئن شوید فایل‌های فونت در `assets/fonts/` قرار دارند
2. نام فایل‌ها باید دقیقاً مطابق `pubspec.yaml` باشد
3. `flutter clean` و سپس `flutter pub get` را اجرا کنید

### مشکل در اجرا

```bash
flutter clean
flutter pub get
flutter run
```

## پشتیبانی

برای گزارش مشکل یا پیشنهاد، لطفاً با توسعه‌دهنده تماس بگیرید.

