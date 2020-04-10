import 'dart:core';
import 'package:angel_framework/angel_framework.dart' as angel;

/// Helper class that retrieves parameters from HTTP requests.

class HttpRequestDetector {
  /// Detects the platform (using "user-agent") from which the given HTTP request was made.
  ///
  /// - req   an HTTP request to process.
  /// Returns the detected platform and version. Detectable platforms: "mobile", "iphone",
  /// "ipad",  "macosx", "android",  "webos", "mac", "windows". Otherwise - "unknown" will
  /// be returned.

  static String detectPlatform(angel.RequestContext req) {
    var ua = req.headers['user-agent'][0];
    var version;

    if (RegExp(r'mobile').hasMatch(ua)) {
        return 'mobile';
    }
    if (RegExp(r'like Mac OS X').hasMatch(ua)) {
        version = RegExp(r'CPU( iPhone)? OS ([0-9\._]+) like Mac OS X').firstMatch(ua).group(1).replaceAll('_', '.'); //exec(ua)[2].replace(/_/g, '.');
        if (RegExp(r'iPhone').hasMatch(ua)) {
            return 'iphone ' + version;
        }
        if (RegExp(r'iPad').hasMatch(ua)) {
            return 'ipad ' + version;
        }
        return 'macosx ' + version;
    }
    if (RegExp(r'Android').hasMatch(ua)) {
        version = RegExp(r'Android ([0-9\.]+)[\);]').firstMatch(ua).group(0); // exec(ua)[1];
        return 'android ' + version;
    }
    if (RegExp(r'webOS/').hasMatch(ua)) {
        version = RegExp(r'webOS\/([0-9\.]+)[\);]').firstMatch(ua).group(0); // exec(ua)[1];
        return 'webos ' + version;
    }
    if (RegExp(r'(Intel|PPC) Mac OS X').hasMatch(ua)) {
        version = RegExp(r'(Intel|PPC) Mac OS X ?([0-9\._]*)[\)\;]').firstMatch(ua).group(1).replaceAll('_', '.');//exec(ua)[2].replace(/_/g, '.');
        return 'mac ' + version;
    }

    if (RegExp(r'Windows NT').hasMatch(ua)) {
        try {
            version = RegExp(r'Windows NT ([0-9\._]+)[\);]').firstMatch(ua).group(0); //exec(ua)[1];
            return 'windows ' + version;
        }
        catch (ex) {
            return 'unknown';
        }
    }
    return 'unknown';
  }

  /// Detects the browser (using "user-agent") from which the given HTTP request was made.
  ///
  /// - req   an HTTP request to process.
  /// Returns the detected browser. Detectable browsers: "chrome", "msie", "firefox",
  ///          "safari". Otherwise - "unknown" will be returned.

  static String detectBrowser(angel.RequestContext req) {
    var ua = req.headers['user-agent'][0];

    if (RegExp(r'chrome').hasMatch(ua)) {
      return 'chrome';
    }
    if (RegExp(r'msie').hasMatch(ua)) {
      return 'msie';
    }
    if (RegExp(r'firefox').hasMatch(ua)) {
      return 'firefox';
    }
    if (RegExp(r'safari').hasMatch(ua)) {
      return 'safari';
    }

    return ua ?? 'unknown';
  }

  /// Detects the IP address from which the given HTTP request was received.
  ///
  /// - req   an HTTP request to process.
  /// Returns the detected IP address (without a port). If no IP is detected -
  /// [null] will be returned.

  static String detectAddress(angel.RequestContext req) {
    var ip;

    if (req.headers['x-forwarded-for'] != null) {
      ip = req.headers['x-forwarded-for'][0];
    }

    if (ip == null && req.ip != null) {
      ip = req.ip;
    }

    ip ??= req.remoteAddress;

    // Remove port
    if (ip != null) {
      ip = ip.toString();
      var index = ip.indexOf(':');
      if (index > 0) {
        ip = ip.substring(0, index);
      }
    }

    return ip;
  }

  /// Detects the host name of the request's destination server.
  ///
  /// - req   an HTTP request to process.
  /// Returns the destination server's host name.

  static String detectServerHost(angel.RequestContext req) {
    return req.uri.host; // socket.localAddress;
  }

  /// Detects the request's destination port number.
  ///
  /// - req   an HTTP request to process.
  /// Returns the detected port number or [80] (if none are detected).

  static String detectServerPort(angel.RequestContext req) {
    return req.uri.port.toString(); //req.socket.localPort;
  }
}
