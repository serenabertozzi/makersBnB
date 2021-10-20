feature 'WEBPAGE: Sign up a New Host' do

  scenario ':sign up' do
    visit('/')
    host_sign_up

    expect(page).to have_content "Host Martin" # Navbar name display
    expect(page).to_not have_content "Guest Jane"
  end

  scenario ':log out' do
    visit('/')
    host_sign_up
    log_out
    expect(page).to_not have_content "Host Martin"
  end

end