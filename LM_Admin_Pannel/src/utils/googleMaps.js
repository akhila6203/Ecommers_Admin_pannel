/**
 * Convert a Google Maps share/view URL into an embeddable iframe src when possible.
 */
export function toGoogleMapsEmbedUrl(url) {
  if (!url?.trim()) return null;
  const trimmed = url.trim();

  if (trimmed.includes("/maps/embed") || trimmed.includes("output=embed")) {
    return trimmed;
  }

  if (trimmed.includes("maps.app.goo.gl") || trimmed.includes("goo.gl/maps")) {
    return null;
  }

  if (trimmed.includes("google.com/maps") || trimmed.includes("maps.google.com")) {
    const separator = trimmed.includes("?") ? "&" : "?";
    return `${trimmed}${separator}output=embed`;
  }

  return null;
}
