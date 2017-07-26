class MessageStore < Hyperloop::Store
  state :messages, scope: :class, reader: :all
  #state :user_name, scope: :class, reader: true

  def self.messages?
    state.messages
  end

  # GetMessages Operation 用来取出 cache 的 messages 的值, 在 helloworld 组件的 after_mount 之后被执行.
  # 注意: 它的调用方式, MessagesOperations::GetMessages.run
  receives MessagesOperations::GetMessages do |params|
    puts "receiving Operations::GetMessages(#{params})"
    # 这是改变 messages state 到一个新的值.
    mutate.messages params.messages
  end

  # Send 将用户输入附加到 cache 的 messages 变量中.
  receives MessagesOperations::Send do |params|
    puts "receiving Operations::Send(#{params})"

    # 这里的 params 其实是在 MessagesOperations::Send 定义中
    # 已经处理过的 params, 即: params.message 其实是一个哈希: {message: 'some_msg'}

    mutate.messages << params.message
  end
end
