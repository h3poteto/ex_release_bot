defmodule Github.PullRequest do
  alias Github.Manager

  def create(%Tentacat.Client{auth: _} = client, timestamp, branch) do
    body = %{
      "title" => "Release #{timestamp}",
      "body" => "Release pull request",
      "head" => "#{Manager.owner()}:#{branch}",
      "base" => "#{Manager.release_branch()}"
    }
    client
    |> Tentacat.Pulls.create(Manager.owner(), Manager.repository(), body)
    |> parse_url
  end

  defp parse_url({201, %{"url" => url}, _}) do
    url
  end
end
