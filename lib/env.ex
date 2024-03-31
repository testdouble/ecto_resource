defmodule EctoCooler.Env do
  def get(key), do: safe_get(Application.fetch_env(:ecto_cooler, key))
  def get(key, default), do: safe_get(Application.fetch_env(:ecto_cooler, key), default)

  defp safe_get(:error, default), do: default
  defp safe_get({:ok, value}, _), do: value
  defp safe_get({:error, _}), do: nil
  defp safe_get({:ok, value}), do: value
end
