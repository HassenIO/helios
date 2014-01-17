class RemoveAirPortName < ActiveRecord::Migration
  def up

      remove_column :rents, :airPortName
      remove_column :travels, :airPortName

  end

  def down

      add_column :travels, :airPortName, :string
      add_column :rents, :airPortName, :string

  end
end
