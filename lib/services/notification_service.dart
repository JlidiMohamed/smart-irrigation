// Conditional import: web uses dart:html, mobile uses stub
export 'notification_service_mobile.dart'
    if (dart.library.html) 'notification_service_web.dart';
