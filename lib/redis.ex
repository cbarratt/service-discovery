defmodule Redis do
  use GenServer

  @initial_state %{ip: nil, socket: nil}

  def start_link(ip) do
    GenServer.start_link(__MODULE__, Map.merge(@initial_state, %{ip: ip}))
  end

  def init(state) do
    opts = [:binary, active: false]

    case :gen_tcp.connect(state.ip, 6379, opts, 1000) do
      {:ok, socket} ->
        {:ok, %{state | socket: socket}}
      {:error, reason} ->
        {:stop, "Failed to connect to #{state.ip} - #{reason}"}
    end
  end

  def command(pid, cmd) do
    GenServer.call(pid, {:command, cmd})
  end

  def handle_call({:command, cmd}, _from, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, cmd)

    {:ok, msg} = :gen_tcp.recv(socket, 0)
    {:reply, msg, state}
  end
end
