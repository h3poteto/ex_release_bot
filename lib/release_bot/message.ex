defmodule ReleaseBot.Message do
  require EEx

  EEx.function_from_file(:def, :body, "message.eex", [:body, :url])
end
