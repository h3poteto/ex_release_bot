defmodule Github.Branch do
  use Timex

  defp base_branch do
    System.get_env("BASE_BRANCH")
  end

  defp release_branch do
    System.get_env("RELEASE_BRANCH")
  end

  defp owner do
    System.get_env("OWNER")
  end

  defp repository do
    System.get_env("REPOSITORY")
  end

  defp new_branch do
    now = Timex.now()
    |> Timex.format!("{YYYY}{0M}{0D}{h24}{0m}{0s}")
    "#{release_branch()}-#{now}"
  end

  def create(%Tentacat.Client{auth: _} = client) do
    revision = client
    |> current_revision()
    body = %{
      "ref" => "refs/heads/#{new_branch()}",
      "sha" => revision
    }
    client
    |> Tentacat.References.create(owner(), repository(), body)
  end

  def current_revision(client) do
    client
    |> Tentacat.References.find(owner(), repository(), "heads/#{base_branch()}")
    |> parse_revision
  end

  defp parse_revision({200, %{"object" => %{"sha" => sha}}, _}) do
    sha
  end
end
