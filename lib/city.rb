class City
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def ==(other_city)
    if other_city != nil
      self.name == other_city.name
    else
      nil
    end
  end

  def self.all
    returned_cities = DB.exec("SELECT * FROM cities;")
    cities = []
    returned_cities.each do |city|
      name = city.fetch('name')
      id = city.fetch('id').to_i
      cities.push(City.new({name:name, id:id}))
    end
    cities
  end

  def save
    result = DB.exec("INSERT INTO cities (name) VALUES ('#{@name}') RETURNING id;")
    id = result.first.fetch('id').to_i
  end

  def self.clear
    DB.exec("DELETE FROM cities *;")
  end

  def self.find(id)
    city = DB.exec("SELECT * FROM cities WHERE id = #{id};").first
    if city
      name = city.fetch('name')
      id = city.fetch('id').to_i
      City.new({name: name, id: id})
    else
      nil
    end
  end

  def update(name)
    @name = name
    DB.exec("UPDATE cities SET name = '#{name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM cities WHERE id = #{@id};")
  end

  def trains
    trains = []
    returned_train_ids = DB.exec("SELECT train_id FROM stops WHERE city_id = #{@id}") # Will give an array of train ids
    if returned_train_ids!= nil
      returned_train_ids.each do |train_id|
        id = train_id.to_i
        name = DB.exec("SELECT name from trains WHERE id = #{id};").first
        trains.push(Train.new({name: name, id:id}))
      end
    end
    trains
  end

end