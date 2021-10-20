feature 'WEBPAGE: Signing up a new Guest' do

  scenario ':sign up' do
    visit('/')
    guest_sign_up
    expect(page).to have_content "Welcome Guest Name"

  end

end