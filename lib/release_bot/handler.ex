defmodule ReleaseBot.Handler do
  use Slack

  def handle_message([user_id, "create", "pull_request"] = _text, channel, slack, user_id) do
    {:ok, pid} = Task.Supervisor.start_link()
    task = Task.Supervisor.async_nolink(pid, Github.Manager, :create_release_pull_request, [])
    send_message("Creating...", channel, slack)
    url = Task.await(task)
    send_message(url, channel, slack)
  end

  def handle_message(_, _, _, _) do
    :ok
  end
end
