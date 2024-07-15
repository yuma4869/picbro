class CreateInputs < ActiveRecord::Migration[7.0]
  def change
    create_table :inputs do |t|
      t.string  :ip
      t.string  :url
      t.text    :text
      t.timestamps
    end
  end
end
