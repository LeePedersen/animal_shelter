class Animal
  attr_reader :id, :name, :gender, :species, :breed


  def initialize(attributes)
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
    @gender = attributes.fetch(:gender)
    @species = attributes.fetch(:species)
    @breed = attributes.fetch(:breed)
  end


  def self.all
    returned_animals = DB.exec("SELECT * FROM animals;")
    animals = []
    returned_animals.each() do |animal|
      name = animal.fetch("name")
      id = animal.fetch("id").to_i
      animals.push(Animal.new({:name => name, :id => id}))
    end
    animals
  end

  def save
    result = DB.exec("INSERT INTO animals (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(animal_to_compare)
    self.name().downcase().eql?(animal_to_compare.name.downcase())
  end

  def self.clear
    DB.exec("DELETE FROM animals *;")
  end

  def self.find(id)
    animal = DB.exec("SELECT * FROM animals WHERE id = #{id};").first
    id = animal.fetch("id").to_i
    name = animal.fetch("name")
    gender = animal.fetch("gender")
    species = animal.fetch("species")
    breed = animal.fetch("breed")
    Animal.new({:name => name, :id => id, :gender => gender, :species => species, :breed => breed})
  end

    def self.search(animal_name)
      animals = []
      returned_animals = DB.exec("SELECT * FROM animals WHERE name LIKE '#{animal_name}%';")
      returned_animals.each() do |animal|
        name = animal.fetch("name")
        id = animal.fetch("id").to_i
        gender = animal.fetch("gender")
        species = animal.fetch("species")
        breed = animal.fetch("breed")
        animals.push(Animal.new({:name => name, :id => id, :gender => gender, :species => species, :breed => breed}))
      end
      animals
    end

  def update(name, gender, species, breed)
    @name = name
    @gender = gender
    @species = species
    @breed = breed
    DB.exec("UPDATE animals SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
  DB.exec("DELETE FROM animals WHERE id = #{@id};")
end
end
