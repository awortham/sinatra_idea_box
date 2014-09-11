class Idea
  include Comparable
  attr_accessor :links

  attr_reader   :title,
                :description,
                :id,
                :rank,
                :category

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @rank        = attributes["rank"] || 0
    @id          = attributes["id"]
    @links       = attributes["links"] || []
    @category    = attributes["category"] || "Work"
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "links" => links,
      "category" => category
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end

  def add_link(link)
    links << link
  end

  def change_category(new_category)
    @category = ""
    @category << new_category
  end
end
