# frozen_string_literal: true

class Comment < Sequel::Model
  plugin :timestamps, update_on_create: true
end
