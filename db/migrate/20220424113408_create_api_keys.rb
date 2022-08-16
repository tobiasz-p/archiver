class CreateAPIKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.string :token

      t.timestamps
    end
  end
end
