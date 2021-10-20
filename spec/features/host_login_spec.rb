feature 'WEBPAGE: Log in Host' do

  scenario ':login' do
    visit('/')
    host_sign_up
    log_out

    host_login
    expect(page).to have_button(value: 'Host Martin') # Navbar name display
  end

  scenario ':log out' do
    visit('/')
    host_sign_up
    log_out
    expect(page).to_not have_content "Host Martin" 
  end
  
end