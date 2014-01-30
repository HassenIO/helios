class AddNbPeopleAndCommentToParkingsTable < ActiveRecord::Migration
  def change
  	add_column :parkings, :nb_people, :integer
  	add_column :parkings, :comment, :text
  end
end
