defmodule ImageDraw do
  @moduledoc """
  Documentation for ImageDraw.
  """
  @default_heigth 250
  @default_width  250
  @doc """
    Function gets an image and render a image binary.
      ## Examples
      iex> IdentityIcon.draw(%IdentityIcon.Image{color: {98, 191, 67},pixel_map: [{{0, 0}, {50, 50}},{{200, 0}, {250, 50}},{{0, 50}, {50, 100}},{{100, 50}, {150, 100}},{{200, 50}, {250, 100}},{{0, 100}, {50, 150}},{{50, 100}, {100, 150}},{{100, 100}, {150, 150}},{{150, 100}, {200, 150}},{{200, 100}, {250, 150}},{{0, 150}, {50, 200}},{{50, 150}, {100, 200}},{{150, 150}, {200, 200}},{{200, 150}, {250, 200}},{{0, 200}, {50, 250}},{{200, 200}, {250, 250}}]})
  """
  def draw(%IdentityIcon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(@default_heigth, @default_width)
    
    Enum.each pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, :egd.color(color))
    end
    
    :egd.render(image)
  end
end
