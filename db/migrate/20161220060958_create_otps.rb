class CreateOtps < ActiveRecord::Migration
  def change
    create_table :otps do |t|
      t.string :phone_number, :limit => 15, :null => false
      t.string :service, :null => false
      t.timestamp :generated_at, :null => false
      t.timestamps
    end
  end
end
