defmodule ReleaseBot.Handler do
  use Slack

  def handle_message([user_id, "create", "pull_request"] = _text, channel, slack, user_id) do
    {:ok, pid} = Task.Supervisor.start_link()
    task = Task.Supervisor.async_nolink(pid, Github.Manager, :create_release_pull_request, [])
    send_message("Creating...", channel, slack)
    url = Task.await(task)
    send_message(url, channel, slack)
  end

  def handle_message([user_id, "release_completed", sha] = _text, channel, slack, user_id) do
    {:ok, pid} = Task.Supervisor.start_link()
    task = Task.Supervisor.async_nolink(pid, Github.Manager, :get_release_body, [sha])
    %{"body" => body, "url" => url} = Task.await(task)
    message = ReleaseBot.Message.body(body, url)
    send_message(message, channel, slack)
  end

  def handle_message([user_id, "ping"] = _text, channel, slack, user_id) do
    send_message("pong", channel, slack)
  end

  def handle_message([user_id, "help"] = _text, channel, slack, user_id) do
    send_message("*create pull_request* - Create a pull request for release in GitHub.\n*release_completed {commit_hash}* - Show pull request body of the release pull rquest.\n*help* - Show this help.", channel, slack)
  end

  def handle_message(_, _, _, _) do
    :ok
  end
end
