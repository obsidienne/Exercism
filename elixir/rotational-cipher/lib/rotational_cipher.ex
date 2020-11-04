defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    shift = rem(shift, 26)

    String.replace(text, ~r/\p{L}/, fn <<char>> -> rotate_char(char, shift) end)
  end

  defp rotate_char(char, shift) when char in ?a..?z do
    if char + shift > ?z do
      char - (26 - shift)
    else
      char + shift
    end
  end

  defp rotate_char(char, shift) when char in ?A..?Z do
    if char + shift > ?Z do
      char - (26 - shift)
    else
      char + shift
    end
  end
end
