class AddAnimalTypeAndBreedToPartners < ActiveRecord::Migration[7.0]
  def change
    add_column :partners, :animal_type, :string, default: '不明', null: false
    add_column :partners, :breed, :string
  end
end
