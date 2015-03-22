require 'spec_helper'

feature 'User can add and reorder videos to queue' do
  background do
    generate_some_videos
    sign_in
  end

  scenario 'User can click a video' do
    click_link "video_#{@video1.id}"
    expect(page).to have_content("#{@video1.title}")
  end

  scenario "User can add a video to their queue" do
    click_link "video_#{@video1.id}"
    click_link "+ My Queue"
    expect(page).to have_content("#{@video1.title}")
    expect(page).to have_content("#{@video1.category.name}")
  end

  scenario "+ My Queue button goes away if video is already in queue" do
    click_link "video_#{@video1.id}"
    click_link "+ My Queue"
    visit video_path(@video1)
    expect(page).to_not have_content("+ My Queue")
  end

  def generate_some_videos
    category = Fabricate(:category)
    @video1 = Fabricate(:video, category: category)
  end
end
