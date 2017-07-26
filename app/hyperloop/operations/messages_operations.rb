module MessagesOperations
  # 注意: 所有基于 Hyperloop::ServerOp 的 operations, 都是仅仅在 Server 执行,
  # 即使这些代码在 client 被调用也如此, 这尤其适合于: 服务端验证, 支付, 或服务端针对文件的操作.
  # 这里的一个猫腻是: 因为以上事实, 这里的代码不被 opal 会翻译成 js, 而是纯粹的 Server 端 Ruby 代码.

  # 不同于普通的 operations , 后者可能只在 client 被运行.

  # 这就意味着另一个猫腻:
  # 下面的 SeverOp 代码, 是不可以使用 Opal 中定义的特定方法调试的.
  # 并且输出 log 信息到 rails log, 而不是 browser log.
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
