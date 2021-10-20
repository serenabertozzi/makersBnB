feature 'WEBPAGE: Sign up a New Host' do

  scenario ':sign up' do
    visit('/')
    host_sign_up
    expect(page).to have_content "Welcome Host Name"
  end

  scenario ':log out' do
    visit('/')
    host_sign_up
    log_out
    expect(page).to_not have_content "Welcome Host Name"
  end

end