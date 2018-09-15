defmodule Github.Manager do
  use Timex
  alias Github.Branch
  alias Github.PullRequest

  def client do
    Tentacat.Client.new(%{access_token: access_token()})
  end

  defp access_token do
    System.get_env("GITHUB_TOKEN")
  end

  def base_branch do
    System.get_env("BASE_BRANCH")
  end

  def release_branch do
    System.get_env("RELEASE_BRANCH")
  end

  def owner do
    System.get_env("OWNER")
  end

  def repository do
    System.get_env("REPOSITORY")
  end

  def create_release_pull_request() do
    timestamp = Timex.now()
    |> Timex.format!("{YYYY}{0M}{0D}{h24}{0m}{0s}")

    branch = client()
    |> Branch.create(timestamp)

    client()
    |> PullRequest.create(timestamp, branch)
  end
end
