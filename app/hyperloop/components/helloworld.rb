class Helloworld < Hyperloop::Component
  before_mount do
    # any initialization particularly of state variables goes here.
    # this will execute on server (prerendering) and client.
    @helloworldmodels = Helloworldmodel.all
  end

  after_mount do
    # any client only post rendering initialization goes here.
    # i.e. start timers, HTTP requests, and low level jquery operations etc.

    # 我们注意到, 在这里, 仅仅调用了 run 方法, 但是没有传递任何 message 哈希过去.
    # 但是在 Store 的 receives 代码块, 仍然有一个 messages 代码块参数.
    # 这就是因为那个 outbound 参数起得作用, 感觉上, outbound 就是像指定一个默认参数?
    MessagesOperations::GetMessages()
  end

  before_update do
    # called whenever a component will be re-rerendered
  end

  before_unmount do
    # cleanup any thing (i.e. timers) before component is destroyed
  end

  render(DIV) do
    InputMessage()
    show_button
    if MyStore.show_field
      DIV(class: 'formdiv') do
        InputBox()
        show_text
      end
    end
    description_table
    Messages() if MessageStore.messages?
  end

  def show_button
    BUTTON(class: 'btn btn-info') do
      'Toggle button'
    end.on(:click) do |ev|
      ShowButtonOp.run(ev: ev)
    end
  end

  def self.toggle_logo(_evt)
    # evt.prevent_default
    logo =Element['img']
    MyStore.show_field ? logo.hide('slow') : logo.show('slow')
  end

  def show_text
    H1 { MyStore.state.field_value.to_s }
  end

  def description_table
    DIV do
      BR
      TABLE(class: 'table table-hover table-condensed') do
        THEAD do
          TR(class: 'table-danger') do
            TD(width: '33%') { 'SAVED HELLO WORLD' }
          end
        end
        TBODY do
          @helloworldmodels.each do |helloworldmodel|
            DescriptionRow(descriptionparam: helloworldmodel.description)
          end
        end
      end
    end
  end
end
