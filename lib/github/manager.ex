defmodule Github.Manager do
  def client do
    Tentacat.Client.new(%{access_token: access_token()})
  end

  defp access_token do
    System.get_env("GITHUB_TOKEN")
  end
end
