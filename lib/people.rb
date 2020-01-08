class Person
  attr_reader :id, :name, :phone, :species, :breed


  def initialize(attributes)
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
    @phone = attributes.fetch(:phone)
    @species = attributes.fetch(:species)
    @breed = attributes.fetch(:breed)
  end


  def self.all
    returned_persons = DB.exec("SELECT * FROM persons;")
    persons = []
    returned_persons.each() do |person|
      name = person.fetch("name")
      id = person.fetch("id").to_i
      phone = person.fetch("phone").to_i
      species = person.fetch("species")
      breed = person.fetch("breed")
      persons.push(Person.new({:name => name, :id => id, :phone => phone, :species => species, :breed => breed}))
    end
    persons
  end

  def save
    result = DB.exec("INSERT INTO persons (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(person_to_compare)
    self.name().downcase().eql?(person_to_compare.name.downcase())
  end

  def self.clear
    DB.exec("DELETE FROM persons *;")
  end

  def self.find(id)
    person = DB.exec("SELECT * FROM persons WHERE id = #{id};").first
    name = person.fetch("name")
    id = person.fetch("id").to_i
    phone = person.fetch("phone").to_i
    species = person.fetch("species")
    breed = person.fetch("breed")
    Person.new({:name => name, :id => id, :phone => phone, :species => species, :breed => breed})
  end

  def self.search(person_name)
    persons = []
    returned_persons = DB.exec("SELECT * FROM persons WHERE name LIKE '#{person_name}%';")
    returned_persons.each() do |person|
      name = person.fetch("name")
      id = person.fetch("id").to_i
      phone = person.fetch("phone").to_i
      species = person.fetch("species")
      breed = person.fetch("breed")
      persons.push(Person.new({:name => name, :id => id, :phone => phone, :species => species, :breed => breed}))
    end
    persons
  end

  def delete
  DB.exec("DELETE FROM animals_persons WHERE person_id = #{@id};")
  DB.exec("DELETE FROM persons WHERE id = #{@id};")
end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE persons SET name = '#{@name}' WHERE id = #{@id};")
    end
    animal_name = attributes.fetch(:animal_name)
    if animal_name != nil
      animal = DB.exec("SELECT * FROM animals WHERE lower(name)='#{animal_name.downcase}';").first
      if animal != nil
        DB.exec("INSERT INTO animals_persons (animal_id, person_id) VALUES (#{animal['id'].to_i}, #{@id});")
      end
    end
  end

  def animals
    animals = []
    results = DB.exec("SELECT animal_id FROM animals_persons WHERE person_id = #{@id};")
    results.each() do |result|
      animal_id = result.fetch("animal_id").to_i()
      animal = DB.exec("SELECT * FROM animals WHERE id = #{animal_id};")
      name = animal.first().fetch("name")
      animals.push(Animal.new({:name => name, :id => animal_id, :gender => gender, :species => species, :breed => breed}))
    end
    animals
  end
end
