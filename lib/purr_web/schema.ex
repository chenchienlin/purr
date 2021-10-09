defmodule MessagePayload do
  defstruct uuid: nil, username: nil, content: nil
end

defmodule UserMessage do
  defstruct type: :user, uuid: nil, username: nil, content: nil
end

defmodule SystemMessage do
  defstruct type: :system, uuid: nil, content: nil
end
