defmodule Github.Commit do
  alias Github.Manager

  def find_pull_request(%Tentacat.Client{auth: _} = client, sha) do
    client
    |> Tentacat.Commits.find(sha, Manager.owner(), Manager.repository())
    |> parse_commit_message
    |> parse_pull_request_number
  end

  defp parse_commit_message({200, %{"commit" => %{"message" => message}}, _}) do
    message
  end

  defp parse_pull_request_number(message) do
    Regex.named_captures(~r/^Merge pull request #(?<number>\d+) from/, message)["number"]
  end
end
