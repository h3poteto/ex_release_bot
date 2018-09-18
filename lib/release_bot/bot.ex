defmodule ReleaseBot.Bot do

  use Slack

  def start_link(initial_state) do
    Slack.Bot.start_link(__MODULE__, initial_state, Application.get_env(:release_bot, :slack_token))
  end

  def handle_connect(slack, state) do
    IO.puts "Connected as #{slack.me.id}"
    Agent.start_link(fn -> slack.me.id end, name: UserInfo)
    {:ok, state}
  end

  def handle_event(message = %{type: "message", text: text}, slack, state) do
    id = Agent.get(UserInfo, &(&1))
    text
    |> String.split(" ")
    |> ReleaseBot.Handler.handle_message(message.channel, slack, "<@#{id}>")
    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}
end
