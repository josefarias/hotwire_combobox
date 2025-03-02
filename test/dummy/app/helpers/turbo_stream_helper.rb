module TurboStreamHelper
  def turbo_stream_action_tag_with_block(
    action,
    target: nil,
    targets: nil,
    **options,
    &block
  )
    template_content = block_given? ? capture(&block) : nil

    turbo_stream_action_tag(
      action,
      target: target,
      targets: targets,
      template: template_content,
      **options
    )
  end
end
