import re

__all__ = ["is_valid_slug", "SLUG_PATTERN"]

# Valid slugs contain lowercase letters, numbers, and single internal dashes.
SLUG_PATTERN: re.Pattern[str] = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")


def is_valid_slug(slug: str) -> bool:
    """Verifica si un slug es valido (solo a-z, 0-9 y -)."""
    return bool(SLUG_PATTERN.match(slug))
