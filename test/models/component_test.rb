require 'test_helper'
require 'custom_markdown'
 
class ComponentTest < ActiveSupport::TestCase
  def test_description_to_html
    testComponent = Component.find(1)
    description = testComponent.description_to_html
    assert description == "<p><span class='first-letter'>h</span>as subcomponent <h2 id='old-tom' class='subcomponent'>old tom • <a href='#table' data-table-link='old%20tom'>0 recipes »</a></h2> with some <a href=\"/ingredients/rye\">rye</a></p>\n"
  end

  def test_description_to_plain_text
    testComponent = Component.find(1)
    description = testComponent.description_as_plain_text
    assert description == "has subcomponent old tom with some rye\n"
  end

  def test_description_updates
    testComponent = Component.find(1)
    testComponent.update_attribute(:description, "this is some :[gin]")
    testComponent.save!
    assert testComponent.description == "this is some :[gin]"
  end

  def test_deletes_and_saves_components
    testComponent = Component.find(1)
    testComponent.update_attribute(:description, "only just ::[old tom]")
    assert testComponent.subcomponents.length == 1
  end

  def test_creates_psuedonyms
    testComponent = Component.find(1)
    testComponent.update_attribute(:pseudonyms_as_markdown, "funny money, Fanny, slock bock")
    assert testComponent.pseudonyms.length == 3
    assert testComponent.pseudonyms.map(&:name).include?("fanny")
    assert testComponent.pseudonyms.map(&:name).include?("funny money")
    assert testComponent.pseudonyms.map(&:name).include?("slock bock")
  end

  def test_recipes
    testRecipe = Recipe.find(1)
    testRecipe.update_attribute(:recipe, "one dash :[gin]")
    testComponent = Component.find(1)
    assert testComponent.list_elements.length == 1
    assert testComponent.list_elements.map(&:name).include?("fooblesniff")
  end

  def test_adds_tags
    testComponent = Component.find(1)
    testComponent.update_attribute(:tags_as_text, "classic, Coupe, cracked ice")
    assert testComponent.tag_list.length == 3
    assert testComponent.tag_list.include?("classic")
    assert testComponent.tag_list.include?("coupe")
    assert testComponent.tag_list.include?("cracked ice")
  end
end
