module MessagesOperations
  class Send < Hyperloop::ServerOp
    param :message
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    step do
      params.message = { message: params.message }
      newcachedmessages = Rails.cache.fetch('messages') { [] } << params.message
      Rails.cache.write('messages', newcachedmessages)
    end
  end

  class GetMessages < Hyperloop::ServerOp
    param :acting_user, nils: true
    dispatch_to { Hyperloop::Application }

    # 下面的 outbound 的特殊声明, 其实是声明了 Store 下面的一个同名的 State.
    # 而之后对 params.messages 的操作, 其实是在操作 Store
    outbound :messages

    step { params.messages = Rails.cache.fetch('messages') { [] } }
  end
end
