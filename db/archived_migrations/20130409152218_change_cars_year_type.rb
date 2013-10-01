class ChangeCarsYearType < ActiveRecord::Migration
  def self.up
    execute 'ALTER TABLE cars ALTER COLUMN km TYPE INTEGER USING km::INTEGER'
  end
  def self.down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
