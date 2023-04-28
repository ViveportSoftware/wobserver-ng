defmodule WobserverNG.Application do
  @moduledoc ~S"""
  Sets up the main routers with Cowboy.
  """

  use Application

  alias Wobserver.Page
  alias Wobserver.Util.Metrics

  require Logger

  @doc ~S"""
  The port the application uses.
  """
  @spec port :: integer
  def port do
    Application.get_env(:wobserver_ng, :port, 4001)
  end

  @doc ~S"""
  Starts `wobserver`.

  The option `:mode` is used to determine how to start `wobserver`.

  The following values are possible:
    - `:standalone`, starts a supervisor that supervises cowboy.
    - `:plug`, passes the Agent storage of the metrics back as pid, without starting any extra processes.

  In `:plug` mode no cowboy/ranch server is started, so the `wobserver` router will need to be called from somewhere else.

  **Note:** both `type` and `args` are unused.
  """
  @spec start(term, term) ::
          {:ok, pid}
          | {:ok, pid, state :: any}
          | {:error, reason :: term}
  def start(type, args) do
    case should_start() do
      true ->
        start_myself(type, args)

      _ ->
        {:error,
         "Exit as config not set to true. Check config :wobserver_ng :enabled in your config.exs."}
    end
  end

  defp should_start() do
    Application.get_env(:wobserver_ng, :enabled, true)
  end

  defp start_myself(_type, _args) do
    # Load pages and metrics from config
    Page.load_config()
    Metrics.load_config()

    # Start cowboy
    case supervisor_children() do
      [] ->
        # Return the metric storage if we're not going to start an application.
        {:ok, Process.whereis(:wobserver_metrics)}

      children ->
        opts = [strategy: :one_for_one, name: Wobserver.Supervisor]
        Supervisor.start_link(children, opts)
    end
  end

  defp supervisor_children do
    case Application.get_env(:wobserver_ng, :mode, :standalone) do
      :standalone ->
        [
          cowboy_child_spec()
        ]

      :plug ->
        []
    end
  end

  defp cowboy_child_spec do
    options = [
      transport_options: [num_acceptors: 10],
      port: WobserverNG.Application.port(),
      dispatch: [
        {:_,
         [
           {"/ws", Wobserver.Web.Client, []},
           {:_, Plug.Cowboy.Handler, {Wobserver.Web.Router, []}}
         ]}
      ]
    ]

    {Plug.Cowboy, scheme: :http, plug: Wobserver.Web.Router, options: options}
  end
end
