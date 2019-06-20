defmodule ImageCreator do
  @moduledoc """
  Documentation for ImageCreator.
  """
  @default_format "png"

  @doc """
    Function that gets a binary, filename, and a format(Optional), and save it to a file.
      ## Examples
      iex> binary = IdentityIcon.draw(%IdentityIcon.Image{color: {98, 191, 67},pixel_map: [{{0, 0}, {50, 50}},{{200, 0}, {250, 50}},{{0, 50}, {50, 100}},{{100, 50}, {150, 100}},{{200, 50}, {250, 100}},{{0, 100}, {50, 150}},{{50, 100}, {100, 150}},{{100, 100}, {150, 150}},{{150, 100}, {200, 150}},{{200, 100}, {250, 150}},{{0, 150}, {50, 200}},{{50, 150}, {100, 200}},{{150, 150}, {200, 200}},{{200, 150}, {250, 200}},{{0, 200}, {50, 250}},{{200, 200}, {250, 250}}]})
      iex> ImageCreator.create!(binary, "Danilo Peres", "png")          
      :ok
  """
  def create!(binary, filename, format \\ @default_format) do
    File.write("#{filename}.#{format}", binary)
  end
end
