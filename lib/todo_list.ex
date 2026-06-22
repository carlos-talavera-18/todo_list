defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      fn entry, list_acc -> add_entry(list_acc, entry) end
    )
  end

  def entries(%TodoList{} = list, date) do
    list.entries
    |> Stream.filter(fn {_, entry}-> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  @spec add_entry(%TodoList{}, %{:date => Date, :title => String}) :: %TodoList{}
  def add_entry(%TodoList{} = list, entry) do
    entry = Map.put(entry, :id, list.auto_id)

    new_entries = Map.put(
      list.entries,
      entry.id,
      entry
    )

    %TodoList{ list |
      auto_id: list.auto_id + 1,
      entries: new_entries
    }
  end

  def update_entry(%TodoList{} = list, id, updater_fun) do
    case Map.fetch(list.entries, id) do
      :error ->
        list
      {:ok, entry} ->
        new_entry = updater_fun.(entry)
        new_entries = Map.put(
          list.entries,
          id,
          new_entry
        )
        %TodoList{list | entries: new_entries}
    end
  end

  def delete_entry(%TodoList{} = list, id) do
    new_entries = Map.delete(list.entries, id)
    %TodoList{list | entries: new_entries}
  end
end
