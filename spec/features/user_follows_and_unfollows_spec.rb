require "spec_helper"

feature "User can follow and unfollow other users" do
  background do
    generate_a_user_to_follow
    sign_in
  end

  scenario 'follow another user' do
    click_link "video_#{@video.id}"
    click_link "#{@another_user.name}"
    click_button "Follow"
    expect(page).to have_content("People I Follow")
    expect(page).to have_content("#{@another_user.name}")
  end

  scenario 'unfollow another user' do
    click_link "video_#{@video.id}"
    click_link "#{@another_user.name}"
    click_button "Follow"
    expect(page).to have_content "#{@another_user.name}"
    click_link "destroy_relationship_#{Relationship.first.id}"
    expect(page).to_not have_content("#{@another_user.name}")
  end

  def generate_a_user_to_follow
    category = Fabricate(:category)
    @video = Fabricate(:video, category: category)
    @another_user = User.create(name: 'Jane Doe', email: 'jane@doe.com', password: 'password')
    @review = Fabricate(:review, video: @video, user: @another_user)
  end
end
