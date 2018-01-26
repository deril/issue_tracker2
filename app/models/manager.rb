class Manager < Person
  has_many :tickets

  def owner_of?(entity)
    return false unless entity.respond_to?(:manager_id)

    entity.manager_id == id
  end
end
