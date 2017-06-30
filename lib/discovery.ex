defmodule Discovery do
  alias Redis

  def scan do
    host = "#{Enum.random(0..256)}.#{Enum.random(0..256)}.#{Enum.random(0..256)}.#{Enum.random(0..256)}" |> String.to_char_list

    case Redis.start_link(host) do
      {:ok, pid} ->
        Redis.command(pid, 'RANDOMKEY\r\n')
      {:error, reason} ->
        IO.puts reason
    end
  end
end
