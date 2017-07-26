class Message < Hyperloop::Component
  param :message

  def render
    TR(class: 'table-success') do
      # 这里 params.message 其实是一个哈希. {message: 'some_msg'}
      TD(width: '50%') { params.message[:message] }
    end
  end
end
