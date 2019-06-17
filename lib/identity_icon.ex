defmodule IdentityIcon do
  @moduledoc """
  Documentation for IdentityIcon.
  """

  def main(input) do
    input
    |> hash_input
    |> create_color
    |> create_table
    |> remove_odds
    |> build_pixel
    |> draw
    |> save(input)
  end
  
  def hash_input(input) do
    %IdentityIcon.Image{hex: :binary.bin_to_list(:crypto.hash(:md5, input))}
  end

  def create_color(%IdentityIcon.Image{hex: [r,g,b | _tail]} = image) do    
    %IdentityIcon.Image{image | color: {r, g, b}}
  end
  
  def create_table(%IdentityIcon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirroring/1)
    |> List.flatten
    |> Enum.with_index
    
    %IdentityIcon.Image{image | grid: grid}
  end
  
  def mirroring(row) do
    [first, second | _tail] = row
    
    row ++ [second, first]
  end
  
  def remove_odds(%IdentityIcon.Image{grid: grid} = image) do
    new_grid = Enum.filter grid, fn {value, _index} ->
      rem(value, 2) == 0
    end
    
    %IdentityIcon.Image{image | grid: new_grid}
  end
  
  def build_pixel(%IdentityIcon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn {_value, index} ->
      heigth = rem(index, 5) * 50
      width = div(index, 5) * 50
      
      top_left = {heigth, width}
      bottom_rigth = {heigth + 50, width + 50}
      
      {top_left, bottom_rigth}
    end
    
    %IdentityIcon.Image{image | pixel_map: pixel_map}
  end
  
  def draw(%IdentityIcon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)
    
    Enum.each pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end
    
    :egd.render(image)
  end
  
  def save(image, input) do
    File.write("#{input}.png", image)
  end
end
