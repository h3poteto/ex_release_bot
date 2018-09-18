defmodule Github.Manager do
  use Timex
  alias Github.Branch
  alias Github.PullRequest

  def client do
    Tentacat.Client.new(%{access_token: access_token()})
  end

  defp access_token do
    Application.get_env(:release_bot, :github_token)
  end

  def base_branch do
    Application.get_env(:release_bot, :base_branch)
  end

  def release_branch do
    Application.get_env(:release_bot, :release_branch)
  end

  def owner do
    Application.get_env(:release_bot, :owner)
  end

  def repository do
    Application.get_env(:release_bot, :repository)
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
