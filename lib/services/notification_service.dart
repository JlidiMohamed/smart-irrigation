// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

// Conditional import: web uses dart:html, mobile uses stub
export 'notification_service_mobile.dart'
    if (dart.library.html) 'notification_service_web.dart';

