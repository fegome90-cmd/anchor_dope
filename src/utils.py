import re

__all__ = ["SLUG_PATTERN", "is_valid_slug", "re"]

# Valid slugs contain lowercase letters, numbers, and non-consecutive internal dashes.
SLUG_PATTERN: re.Pattern[str] = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")


def is_valid_slug(slug: str) -> bool:
    """Verifica si un slug es valido (solo a-z, 0-9 y -)."""
    return bool(SLUG_PATTERN.match(slug))
