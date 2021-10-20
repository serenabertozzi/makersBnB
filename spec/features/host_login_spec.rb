feature 'WEBPAGE: Log in Host' do

  scenario ':login' do

    host_sign_up
    
    visit('/')
    
    find(:xpath, "/html/body/nav/div/div/form[2]/input").click
   
    fill_in 'first_name', with: 'Host Name'
    fill_in 'last_name', with: 'Surname'
    fill_in 'email', with: 'Host@mailer.com'
    fill_in 'password', with: 'test_password'
    fill_in 'password_confirmation', with: 'test_password'
    check 'host'
    click_button 'Submit'
    expect(page).to have_content "Welcome Host Name"



  end

end