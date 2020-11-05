defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    codons = String.split(rna, ~r/[A-Z]{1,3}/, include_captures: true, trim: true)

    Enum.reduce_while(codons, [], fn codon, acc ->
      case of_codon(codon) do
        {:ok, "STOP"} -> {:halt, acc}
        {:ok, protein} -> {:cont, acc ++ [protein]}
        {:error, _} -> {:halt, :error}
      end
    end)
    |> protein_format()
  end

  defp protein_format(proteins) when is_list(proteins), do: {:ok, proteins}
  defp protein_format({:halt, proteins}), do: {:ok, proteins}
  defp protein_format(:error), do: {:error, "invalid RNA"}

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """

  @codons %{
    "UGU" => {:ok, "Cysteine"},
    "UGC" => {:ok, "Cysteine"},
    "UUA" => {:ok, "Leucine"},
    "UUG" => {:ok, "Leucine"},
    "AUG" => {:ok, "Methionine"},
    "UUU" => {:ok, "Phenylalanine"},
    "UUC" => {:ok, "Phenylalanine"},
    "UCU" => {:ok, "Serine"},
    "UCC" => {:ok, "Serine"},
    "UCA" => {:ok, "Serine"},
    "UCG" => {:ok, "Serine"},
    "UGG" => {:ok, "Tryptophan"},
    "UAU" => {:ok, "Tyrosine"},
    "UAC" => {:ok, "Tyrosine"},
    "UAA" => {:ok, "STOP"},
    "UAG" => {:ok, "STOP"},
    "UGA" => {:ok, "STOP"}
  }

  @invalid_codon {:error, "invalid codon"}

  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    Map.get(@codons, codon, @invalid_codon)
  end
end
