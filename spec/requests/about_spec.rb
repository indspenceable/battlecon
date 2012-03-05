require 'spec_helper'

describe "The about page" do
  it "should allow users to navigate to the about page." do
    visit '/'
    click_link('About')
    page.should have_content "About battlecon"
  end
end