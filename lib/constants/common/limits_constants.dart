class PageSizes {
  const PageSizes._();

  static const int feed = 10;
  static const int comments = 10;
  static const int adminRequests = 10;
}

/// Mirrors server validation so forms fail fast; the server stays authoritative.
class TextLimits {
  const TextLimits._();

  static const int videoTitleMax = 120;
  static const int videoDescriptionMax = 2000;
  static const int commentMax = 1000;
  static const int adminReasonMin = 10;
  static const int adminReasonMax = 500;
}

class Timings {
  const Timings._();

  static const Duration searchDebounce = Duration(milliseconds: 400);
}

/// Distance from the list end at which the next page starts loading.
const double kLoadMoreThreshold = 400;
