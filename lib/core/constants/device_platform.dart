/// Contains information of supported device platforms.
///
/// Use [Platform] to obtain values for [isAndroid] or [isIos] when app is
/// first bootstrapped and pass this enum to classes that need it.
///
/// By depending on this class instead of directly on [Platform], we can
/// mock platform information in our tests.
enum DevicePlatform { android, ios }
