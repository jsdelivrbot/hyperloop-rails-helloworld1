module MessagesOperations
  class Send < Hyperloop::ServerOp
    # 这里的 param 表示, 执行 operation 的时候, 必须传递 message 参数进来.
    param :message
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    step do
      # 与下面的 outbound 声明不同, 传进来的参数作为 params.message
      # 会首先在这里被处理 (拼一个 哈希)
      params.message = { message: params.message }

      # 把新增的 params.message 附在 messages 列表后面.
      newcachedmessages = Rails.cache.fetch('messages') { [] } << params.message
      # 存储更新之后的 messages cacej
      Rails.cache.write('messages', newcachedmessages)
    end
  end

  class GetMessages < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    # 如果这里指定了 outbound, 你可以直接在 Operations 中传递一个值到
    # receives 的 blocks 作为代码块参数(无须在执行 operation 时传递)
    # 否则的话, 就像 Send 一样, 你其实需要在 onlick 事件中, 执行 operation 时,
    # 将 message 传递到 store.
    outbound :messages

    step { params.messages = Rails.cache.fetch('messages') { [] } }
  end
end
