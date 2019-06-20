defmodule IdentityIcon do
  @moduledoc """
  Documentation for IdentityIcon.
  """

  @doc """
    Function to transform a string to image.
      ##Example
      iex> IdentityIcon.generate_image_from("Danilo Peres")          
      :ok
  """
  def generate_image_from(input) do
    input
    |> hash_input
    |> create_color
    |> create_table
    |> remove_odds
    |> build_pixel
    |> ImageDraw.draw
    |> ImageCreator.create!(input)
  end

  @doc """
    Function that gets an input and generate a image struck with its binary.
      ##Example
      iex> IdentityIcon.hash_input("Danilo Peres")
      %IdentityIcon.Image{color: nil,grid: nil,hex: [253, 115, 8, 10, 232, 124, 65, 71, 211, 251, 98, 87, 244, 122, 69, 54],pixel_map: nil}
  """
  def hash_input(input) do
    %IdentityIcon.Image{hex: :binary.bin_to_list(:crypto.hash(:md5, input))}
  end

  @doc """
    Function that gets an image with its binary, and gets the 3 first elements and generate RGB.
      ##Example
      iex> image_with_binary = IdentityIcon.hash_input("Danilo Peres")
      iex> IdentityIcon.create_color(image_with_binary)
      %IdentityIcon.Image{color: {253, 115, 8},grid: nil,hex: [253, 115, 8, 10, 232, 124, 65, 71, 211, 251, 98, 87, 244, 122, 69, 54],pixel_map: nil}
  """
  def create_color(%IdentityIcon.Image{hex: [r,g,b | _tail]} = image) do
    %IdentityIcon.Image{image | color: {r, g, b}}
  end

  @doc """
    Function that gets an image with its binary, and generate a table with grid.
      ##Example
      iex> image_with_binary = IdentityIcon.hash_input("Danilo Peres")
      iex> IdentityIcon.create_table(image_with_binary)
      %IdentityIcon.Image{color: nil,grid: [{253, 0},{115, 1},{8, 2},{115, 3},{253, 4},{10, 5},{232, 6},{124, 7},{232, 8},{10, 9},{65, 10},{71, 11},{211, 12},{71, 13},{65, 14},{251, 15},{98, 16},{87, 17},{98, 18},{251, 19},{244, 20},{122, 21}, {69, 22},{122, 23},{244, 24}],hex: [253, 115, 8, 10, 232, 124, 65, 71, 211, 251, 98, 87, 244, 122, 69, 54],pixel_map: nil}
  """
  def create_table(%IdentityIcon.Image{hex: hex} = image) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.map(&mirroring/1)
    |> List.flatten
    |> Enum.with_index
    
    %IdentityIcon.Image{image | grid: grid}
  end

  @doc """
    Function that a array with 3 elements and mirror its elements.
      ##Example
      iex> IdentityIcon.mirroring([1,2,3])
      [1, 2, 3, 2, 1]
  """
  def mirroring(row) do
    [first, second | _tail] = row
    
    row ++ [second, first]
  end

  @doc """
    Function that gets an image with a grid, and remove all odd items.
      ##Example
      iex> IdentityIcon.remove_odds(%IdentityIcon.Image{grid: [{253, 0},{115, 1},{8, 2},{115, 3},{253, 4},{10, 5},{232, 6},{124, 7},{232, 8},{10, 9},{65, 10},{71, 11},{211, 12},{71, 13},{65, 14},{251, 15},{98, 16},{87, 17},{98, 18},{251, 19},{244, 20},{122, 21}, {69, 22},{122, 23},{244, 24}]})
      %IdentityIcon.Image{color: nil,grid: [{8, 2},{10, 5},{232, 6},{124, 7},{232, 8},{10, 9},{98, 16},{98, 18},{244, 20},{122, 21},{122, 23},{244, 24}],hex: nil,pixel_map: nil}
  """
  def remove_odds(%IdentityIcon.Image{grid: grid} = image) do
    new_grid = Enum.filter grid, fn {value, _index} ->
      rem(value, 2) == 0
    end
    
    %IdentityIcon.Image{image | grid: new_grid}
  end
  
  @doc """
    Function that gets an image with a grid, and create the pixel_map.
      ##Example
      iex> image_with_grid = IdentityIcon.remove_odds(%IdentityIcon.Image{grid: [{253, 0},{115, 1},{8, 2},{115, 3},{253, 4},{10, 5},{232, 6},{124, 7},{232, 8},{10, 9},{65, 10},{71, 11},{211, 12},{71, 13},{65, 14},{251, 15},{98, 16},{87, 17},{98, 18},{251, 19},{244, 20},{122, 21}, {69, 22},{122, 23},{244, 24}]})
      iex> IdentityIcon.build_pixel(image_with_grid)
      %IdentityIcon.Image{color: nil,grid: [{8, 2},{10, 5},{232, 6},{124, 7},{232, 8},{10, 9},{98, 16},{98, 18},{244, 20},{122, 21},{122, 23},{244, 24}],hex: nil,pixel_map: [{{100, 0}, {150, 50}},{{0, 50}, {50, 100}},{{50, 50}, {100, 100}},{{100, 50}, {150, 100}},{{150, 50}, {200, 100}},{{200, 50}, {250, 100}},{{50, 150}, {100, 200}},{{150, 150}, {200, 200}},{{0, 200}, {50, 250}},{{50, 200}, {100, 250}},{{150, 200}, {200, 250}},{{200, 200}, {250, 250}}]}
  """
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
end
