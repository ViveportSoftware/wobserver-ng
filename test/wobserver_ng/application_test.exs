defmodule WobserverNG.ApplicationTest do
  use ExUnit.Case

  describe "port" do
    test "returns a default port" do
      assert WobserverNG.Application.port() > 0
    end

    test "returns a set port" do
      :meck.new(Application, [:passthrough])

      :meck.expect(Application, :get_env, fn :wobserver_ng, option, _ ->
        case option do
          :mode -> :plug
          :pages -> []
          :metrics -> []
          :discovery -> :none
          :port -> 8888
          :enabled -> true
        end
      end)

      on_exit(fn -> :meck.unload() end)

      assert WobserverNG.Application.port() == 8888
    end
  end

  describe "start" do
    test "as app starts cowboy with :standalone set" do
      :meck.new(Application, [:passthrough])

      :meck.expect(Application, :get_env, fn :wobserver_ng, option, _ ->
        case option do
          :mode -> :standalone
          :discovery -> :none
          :pages -> []
          :metrics -> []
          :port -> 8888
          :enabled -> true
        end
      end)

      on_exit(fn -> :meck.unload() end)

      case WobserverNG.Application.start(:normal, []) do
        {:error, data} -> assert data == {:already_started, Process.whereis(Wobserver.Supervisor)}
        data -> assert data == {:ok, Process.whereis(Wobserver.Supervisor)}
      end
    end

    test "as plug returns metrics storage pid" do
      :meck.new(Application, [:passthrough])

      :meck.expect(Application, :get_env, fn :wobserver_ng, option, _ ->
        case option do
          :mode -> :plug
          :discovery -> :none
          :pages -> []
          :metrics -> []
          :port -> 8888
          :enabled -> true
        end
      end)

      on_exit(fn -> :meck.unload() end)

      assert WobserverNG.Application.start(:normal, []) ==
               {:ok, Process.whereis(:wobserver_metrics)}
    end

    test "as configured enabled = false" do
      :meck.new(Application, [:passthrough])

      :meck.expect(Application, :get_env, fn :wobserver_ng, option, _ ->
        case option do
          :mode -> :plug
          :discovery -> :none
          :pages -> []
          :metrics -> []
          :port -> 8888
          :enabled -> false
        end
      end)

      on_exit(fn -> :meck.unload() end)

      assert WobserverNG.Application.start(:normal, []) ==
               {:error,
                "Exit as config not set to true. Check config :wobserver_ng :enabled in your config.exs."}
    end

    test "as configured enabled = anything except true" do
      :meck.new(Application, [:passthrough])

      :meck.expect(Application, :get_env, fn :wobserver_ng, option, _ ->
        case option do
          :mode -> :plug
          :discovery -> :none
          :pages -> []
          :metrics -> []
          :port -> 8888
          :enabled -> 123
        end
      end)

      on_exit(fn -> :meck.unload() end)

      assert WobserverNG.Application.start(:normal, []) ==
               {:error,
                "Exit as config not set to true. Check config :wobserver_ng :enabled in your config.exs."}
    end
  end
end
