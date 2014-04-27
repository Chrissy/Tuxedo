require 'recipe.rb'
require 'component.rb'

class List < ActiveRecord::Base
  serialize :element_ids, Array

  def elements
    elements = []
    element_ids.each do |element_pair|
      element_collection = expand_element_pair(element_pair)
      elements << element_collection
    end
    elements.flatten
  end

  def compile_and_store_list_elements
    elements = collect_list_elements(content_as_markdown)
    self.update_attribute(:element_ids, elements)
  end

  def expand_element_pair(element_pair)
    element_collection = []
    if element_pair[1][/(\bALL\b|\bALPH\b|\bDATE\b|\d+)/]
      element_collection = expand_list_code(element_pair[1])
    else
      element_collection = element_pair[0].singularize.classify.constantize.find_by_name(element_pair[1])
    end
    element_collection
  end

  def expand_list_code(list_code)
    first_word = list_code[/([^\s]+)/]
    number = list_code[/\d+/].to_i
    number = 10 if number.zero? 
    type = list_code[/(\bDATE\b)/]
    if first_word == "ALL" || first_word == "all"
      Recipe.limit(number).order(type.nil? ? "name asc" : "last_updated desc").to_a
    else
      component = Component.find_by_name(first_word)
      if type.nil?
        component.recipes.sort_by!(&:name)
      else 
        component.recipes.sort { |a,b| a.last_updated <=> b.last_updated }
      end
    end
  end

  def collect_list_elements(md)
    recipes = []
    md.gsub(/(\=|\:|\#)\[(.*?)\]/) do |*|
      case $1
        when ":" 
          recipes.push([Component.to_s, $2])
        when "#" 
          recipes.push([List.to_s, $2])
        when "=" 
          recipes.push([Recipe.to_s, $2])
      end
    end
    return recipes
  end
end