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
    click_link @video1.title
    expect(page).to_not have_content("+ My Queue")
    expect(page).to have_content("Watch Now")
  end

  scenario "add a few videos to queue and check their order" do
    click_link "video_#{@video1.id}"
    click_link "+ My Queue"
    visit home_path
    click_link "video_#{@video2.id}"
    click_link "+ My Queue"
    visit home_path
    click_link "video_#{@video3.id}"
    click_link "+ My Queue"
    expect(page).to have_content @video1.title
    expect(page).to have_content @video2.title
    expect(page).to have_content @video3.title
  end

  scenario "add a few videos to queue and check their order" do
    click_link "video_#{@video1.id}"
    click_link "+ My Queue"
    visit home_path
    click_link "video_#{@video2.id}"
    click_link "+ My Queue"
    visit home_path
    click_link "video_#{@video3.id}"
    click_link "+ My Queue"

    expect(video_position(@video3)).to eq("3")
  end

  scenario "change the order of the queue items and check their position" do
    click_link "video_#{@video1.id}"
    click_link "+ My Queue"
    visit home_path
    click_link "video_#{@video2.id}"
    click_link "+ My Queue"
    visit home_path
    click_link "video_#{@video3.id}"
    click_link "+ My Queue"
    within find(:xpath, "//tr[contains(.,'#{@video1.title}')]") do
      fill_in "queue_items[][position]", with: "4"
    end
    click_button("Update Instant Queue")
    expect(video_position(@video1)).to eq("3")
    expect(video_position(@video2)).to eq("1")
    expect(video_position(@video3)).to eq("2")
  end

  def video_position(video)
    find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type = 'text']").value
  end

  def generate_some_videos
    category = Fabricate(:category)
    @video1 = Fabricate(:video, category: category)
    @video2 = Fabricate(:video, category: category)
    @video3 = Fabricate(:video, category: category)
  end
end
