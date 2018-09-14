defmodule ReleaseBot.Handler do
  use Slack

  def handle_message([user_id, "create", "pull_request"] = _text, channel, slack, user_id) do
    send_message("I got a message!", channel, slack)
  end

  def handle_message(_, _, _, _) do
    :ok
  end
end
