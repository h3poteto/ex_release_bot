defmodule Github.Body do
  require EEx

  EEx.function_from_file(:def, :body, "template.eex", [:pulls])
end
