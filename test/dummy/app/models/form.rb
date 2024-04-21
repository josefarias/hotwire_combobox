class Form
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :state_id, :integer, default: State.first.id

  def state
    State.find state_id
  end
end
