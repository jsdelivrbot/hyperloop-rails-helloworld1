class Messages < Hyperloop::Component
  def render
    DIV do
      BR {}
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { "SENT MESSAGES" }
          end
        end

        TBODY do
          MessageStore.all.each do |message|
            # 这里传入的 message 其实是一个哈希: {message: 'some_msg'}
            Message message: message
          end
        end
      end
    end
  end
end
