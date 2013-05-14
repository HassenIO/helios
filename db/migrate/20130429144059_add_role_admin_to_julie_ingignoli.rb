class AddRoleAdminToJulieIngignoli < ActiveRecord::Migration
  def change
    user = User.find_by_email("julie.ingignoli@gmail.com")

    #if user && (!user.has_role? :admin)
    #  user.addRole("admin")
    #end

  end
end
