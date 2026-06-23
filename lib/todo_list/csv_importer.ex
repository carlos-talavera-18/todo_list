defmodule TodoList.CsvImporter do
  alias TodoList.Item

  def import(file) do
    Path.expand(file, __DIR__)
    |> File.stream!()
    |> Stream.drop(1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
    |> TodoList.new()
  end

  defp parse_line(line) do
    [date, title] =
      line
      |> String.trim()
      |> String.split(",", parts: 2)

    %Item{
      date: date,
      title: title
    }
  end
end
