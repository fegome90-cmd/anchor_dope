from src.utils import is_valid_slug


class TestIsValidSlug:
    """Cobertura completa de is_valid_slug."""

    def test_valid_simple_slug(self) -> None:
        assert is_valid_slug("sprint-valido-01") is True

    def test_invalid_uppercase(self) -> None:
        assert is_valid_slug("Sprint_Invalido!") is False

    def test_empty_string(self) -> None:
        assert is_valid_slug("") is False

    def test_leading_dash(self) -> None:
        assert is_valid_slug("-sprint") is False

    def test_trailing_dash(self) -> None:
        assert is_valid_slug("sprint-") is False

    def test_double_dash(self) -> None:
        assert is_valid_slug("sprint--doble") is False

    def test_numbers_only(self) -> None:
        assert is_valid_slug("123") is True

    def test_letters_only(self) -> None:
        assert is_valid_slug("abc") is True

    def test_single_char(self) -> None:
        assert is_valid_slug("a") is True

    def test_valid_with_hyphens(self) -> None:
        assert is_valid_slug("a-b-c-1-2-3") is True

    def test_invalid_uppercase_single(self) -> None:
        assert is_valid_slug("A") is False

    def test_invalid_space(self) -> None:
        assert is_valid_slug("a b") is False

    def test_invalid_underscore(self) -> None:
        assert is_valid_slug("a_b") is False

    def test_invalid_dot(self) -> None:
        assert is_valid_slug("slug.muy.largo") is False
