class AddIsProfessorToPerson < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :is_professor, :boolean
  end
end
