class CreateRoleAbilities < ActiveRecord::Migration[7.1]
  def change
    create_table :role_abilities do |t|
      t.references :role, null: false, foreign_key: true
      t.references :ability_permission, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :role_abilities, [:role_id, :ability_permission_id], unique: true, name: 'index_role_abilities_on_role_and_permission'
  end
end
