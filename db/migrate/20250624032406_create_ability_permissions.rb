class CreateAbilityPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :ability_permissions do |t|
      t.string :action, null: false
      t.string :subject, null: false
      t.text :description

      t.timestamps
    end
    
    add_index :ability_permissions, [:action, :subject], unique: true
  end
end
