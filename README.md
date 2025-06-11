# 📱 Flutter Bootcamp - Quotes App (Hafta 3)

Bu hafta, Flutter ile geliştirdiğimiz Quotes uygulamasında, alıntıların favorilere eklenmesi (shared_preferences paketi ile) için gerekli değişiklikleri yaparak bootcampimizi tamamladık.

---

## 🚀 Kurulum Adımları

### 1. Gerekli Paketleri Yükleyin

```bash
flutter pub get
```

---

### 2. Uygulama İkonunu Oluşturun

```bash
dart run flutter_launcher_icons
```

> `flutter_launcher_icons` yapılandırmasını unutmayın.

---

### 3. Splash Screen (Açılış Ekranı) Oluşturun

```bash
dart run flutter_native_splash:create
```

> Splash ekranınızın `flutter_native_splash` konfigürasyonu `flutter_native_splash` içinde yer almalıdır.

---

### 4. iOS Bağımlılıklarını Kurun

```bash
cd ios
pod install
cd ..
```

---

## ✅ Notlar

- Tüm bu işlemler sonrasında projeyi tekrar derleyin:

```bash
flutter clean
flutter run
```

- iOS tarafında ilk derlemede Xcode ile açmanız gerekebilir.
- Splash ve ikon işlemlerinden sonra emülatörde yeniden başlatma (hot restart) önerilir.

---

## 📦 Kullanılan Paketler

- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)

---

🎉 Artık uygulamanız görsel olarak hazır ve çalıştırılabilir durumda!
