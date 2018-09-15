defmodule Github.Branch do
  alias Github.Manager

  defp new_branch(timestamp) do
    "#{Manager.release_branch()}-#{timestamp}"
  end

  def create(%Tentacat.Client{auth: _} = client, timestamp) do
    revision = client
    |> current_revision()
    body = %{
      "ref" => "refs/heads/#{new_branch(timestamp)}",
      "sha" => revision
    }
    client
    |> Tentacat.References.create(Manager.owner(), Manager.repository(), body)
    |> parse_branch
  end

  def current_revision(client) do
    client
    |> Tentacat.References.find(Manager.owner(), Manager.repository(), "heads/#{Manager.base_branch()}")
    |> parse_revision
  end

  defp parse_revision({200, %{"object" => %{"sha" => sha}}, _}) do
    sha
  end

  defp parse_branch({201, %{"ref" => ref}, _}) do
    ref
    |> String.split("/")
    |> ref_branch
  end

  defp ref_branch([_, _, branch]) do
    branch
  end
end
