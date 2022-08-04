# test_app_flutter
Test OAuth app written in Flutter

## Setting up your development environment

1. Install rosetta

```
sudo softwareupdate --install-rosetta --agree-to-license
```

2. Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
3. Add Flutter to PATH

```
export PATH="$PATH:`pwd`/flutter/bin"
```

4. Install CocoaPods

```
sudo gem install cocoapods
sudo gem uninstall ffi && sudo gem install ffi -- --enable-libffi-alloc
```

5. Install [Android Studio](https://developer.android.com/studio?gclsrc=aw.ds&gclid=CjwKCAjw3K2XBhAzEiwAmmgrAn97-JRUgf2kzyojCS0IUKsBa9A6uWiqrytVSNdnO5pGnWCK8-xXURoCMQQQAvD_BwE)
6. Install [Android cmdline-tools](https://developer.android.com/studio/command-line)
7. Accept outstanding Android licenses

```
flutter doctor --android-licenses
```

8. Check Flutter install is working

```
flutter doctor
```

9. Install [Visual Studio Code](https://code.visualstudio.com/)
10. Install [Flutter and Dart plugins](https://docs.flutter.dev/get-started/editor?tab=vscode)
