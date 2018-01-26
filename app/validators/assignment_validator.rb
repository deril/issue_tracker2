# frozen_string_literal: true

class AssignmentValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.public_send("#{attribute}_changed?")
    return if record.public_send("#{attribute}_was").nil?
    return if record.public_send("#{attribute}").nil?

    record.errors[attribute] << "cannot be changed"
  end
end
