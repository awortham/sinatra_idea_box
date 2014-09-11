require 'yaml/store'

class IdeaStore
  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id.to_i)
    end
  end

  def self.update(id, data)
    database.transaction do
      existing_data = database['ideas'][id]
      database['ideas'][id] = existing_data.merge(data)
    end
  end

  def self.create(data)
    database.transaction do
      database['ideas'] << data
    end
  end

  def self.remove_link(id, link)
    idea = find(id.to_i)
    idea.links.reject! {|l| l if l.include?(link)}
    database.transaction do
      database['ideas'][id] = idea.to_h
    end
  end

  def self.change_category(id, category)
    idea = find(id)
    idea.change_category(category)
    database.transaction do
      database['ideas'][id] = idea.to_h
    end
  end
end
