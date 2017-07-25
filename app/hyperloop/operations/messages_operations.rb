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
end
