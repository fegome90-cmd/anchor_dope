import pytest
from src.utils import is_valid_slug


@pytest.mark.unit
class TestIsValidSlug:
    """Cobertura completa de is_valid_slug."""

    @pytest.mark.parametrize(
        "slug,expected",
        [
            # Valid
            ("sprint-valido-01", True),
            ("123", True),
            ("abc", True),
            ("a", True),
            ("a-b-c-1-2-3", True),
            # Invalid: empty
            ("", False),
            # Invalid: uppercase
            ("A", False),
            ("Sprint_Invalido!", False),
            # Invalid: dash position
            ("-sprint", False),
            ("sprint-", False),
            ("sprint--doble", False),
            # Invalid: special chars
            ("a b", False),
            ("a_b", False),
            ("slug.muy.largo", False),
        ],
    )
    def test_is_valid_slug(self, slug: str, expected: bool) -> None:
        """Test is_valid_slug with multiple inputs."""
        assert is_valid_slug(slug) is expected
