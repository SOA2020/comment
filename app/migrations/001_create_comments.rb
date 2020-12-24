# frozen_string_literal: true

Sequel.migration do
  transaction
  change do
    create_table(:comments) do
      primary_key :id
      String :commodity_id, size: 255, null: false
      String :user_id, size: 255, null: false
      String :content, text: true, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
      unique [:user_id, :commodity_id]
    end
  end
end
