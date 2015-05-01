require 'spec_helper'

feature 'Admin logs in, adds a video then logs out. User logs in and watches video' do
  background do
    admin_sign_in
    create_categories
  end

  scenario 'Admin adds a video' do
    click_link "Add a new video"

    expect(page).to have_content("Add a New Video")

    fill_in "Title", with: "The Walking Dead E10"
    select "TV Dramas", from: "Category"
    fill_in "Description", with: "Zombie Apocolypse"
    attach_file "Large cover", "#{Rails.root}/public/tmp/walking_dead_large.jpg"
    attach_file "Small cover", "#{Rails.root}/public/tmp/walking_dead.jpg"
    fill_in "Video url", with: "https://s3.amazonaws.com/myflix-cmqzlnwe/videos/The.Walking.Dead.S05E10.HDTV.x264-KILLERS.mp4"
    click_button "Add Video"

    expect(page).to have_content("You successfully added The Walking Dead E10")
  end

  def create_categories
    Category.create(name: "TV Comedies")
    Category.create(name: "TV Dramas")
  end

end
