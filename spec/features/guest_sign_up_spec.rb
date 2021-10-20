feature 'WEBPAGE: Signing up a new Guest' do

  scenario ':sign up' do
    visit('/')
    guest_sign_up
    expect(page).to have_content "Guest Jane" # Navbar name display
    expect(page).to_not have_content "Host Martin"
  end

  scenario ':log out' do
    visit('/')
    guest_sign_up
    log_out
    expect(page).to_not have_content "Guest Jane" 
  end
end