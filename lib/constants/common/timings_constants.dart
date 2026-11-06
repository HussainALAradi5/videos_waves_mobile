class Timings {
  const Timings._();

  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const Duration refreshDebounce = Duration(milliseconds: 300);
  static const Duration typingIdle = Duration(seconds: 3);
  static const Duration typingExpiry = Duration(seconds: 6);
  static const Duration voiceTick = Duration(seconds: 1);
}

/// Distance from the list end at which the next page starts loading.
const double kLoadMoreThreshold = 400;
