class CreateDealSheets < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_sheets do |t|
      t.text :details
      t.string :confirm_token
      t.boolean :confirmed

      t.timestamps
    end
  end
end
