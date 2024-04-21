class Form
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :state_id

  def state
    State.find state_id
  end

  def state_id
    @state_id || State.first.id
  end
end
