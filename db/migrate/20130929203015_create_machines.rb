class CreateMachines < ActiveRecord::Migration
  def up
    create_table :machines do |t|
      t.string :machine_id
      t.text :json
      t.string :version
      t.timestamps
    end
  end

  def down
    drop_table :machines
  end
end
