defmodule Github.PullRequest do
  alias Github.Manager
  alias Github.Body

  def create(%Tentacat.Client{auth: _} = client, timestamp, branch) do
    body = %{
      "title" => "Release #{timestamp}",
      "body" => "Release pull request",
      "head" => "#{Manager.owner()}:#{branch}",
      "base" => "#{Manager.release_branch()}"
    }
    response = client
    |> Tentacat.Pulls.create(Manager.owner(), Manager.repository(), body)

    number = response
    |> parse_number

    numbers = client
    |> list_commit_messages(number)
    |> find_pull_request_number

    body_message = client
    |> build_body_message(numbers)

    new_body = %{
      "body" => body_message
    }
    client
    |> Tentacat.Pulls.update(Manager.owner(), Manager.repository(), number, new_body)

    response
    |> parse_url
  end

  defp parse_url({201, %{"html_url" => url}, _}) do
    url
  end

  defp parse_number({201, %{"number" => number}, _}) do
    number
  end

  def list_commit_messages(client, number) do
    client
    |> Tentacat.Pulls.Commits.list(Manager.owner(), Manager.repository(), number)
    |> parse_commit_messages()
  end

  defp parse_commit_messages({200, commits, _}) do
    commits
    |> Enum.map(fn(%{"commit" => %{"message" => message}}) -> message end)
  end

  def find_pull_request_number(messages) do
    messages
    |> Enum.filter(fn(m) ->
      Regex.match?(~r/^Merge pull request #/, m)
    end)
    |> Enum.map(fn(m) ->
      Regex.named_captures(~r/^Merge pull request #(?<number>\d+) from/, m)["number"]
    end)
  end

  def build_body_message(client, numbers) do
    numbers
    |> Enum.map(fn(n) ->
      pull_request_title(client, n)
    end)
    |> Body.body
  end

  def pull_request_title(client, number) do
    client
    |> Tentacat.Pulls.find(Manager.owner(), Manager.repository(), number)
    |> parse_title_and_url
  end

  defp parse_title_and_url({200, %{"title" => title, "html_url" => url, "number" => number}, _}) do
    %{
      "title" => title,
      "url" => url,
      "number" => number
    }
  end

  def get_body(%Tentacat.Client{auth: _} = client, number) do
    client
    |> Tentacat.Pulls.find(Manager.owner(), Manager.repository(), number)
    |> parse_body_and_url
  end

  defp parse_body_and_url({200, %{"html_url" => url, "body" => body}, _}) do
    %{
      "body" => body,
      "url" => url
    }
  end
end
