
def host_sign_up
  find(:xpath, "/html/body/nav/div/div/form[1]/input").click
    fill_in 'first_name', with: 'Host Name'
    fill_in 'last_name', with: 'Surname'
    fill_in 'email', with: 'Host@mailer.com'
    fill_in 'password', with: 'test_password'
    fill_in 'password_confirmation', with: 'test_password'
    check 'host'
    click_button 'Submit'
end

def guest_sign_up
  find(:xpath, "/html/body/nav/div/div/form[1]/input").click
   
  fill_in 'first_name', with: 'Guest Name'
  fill_in 'last_name', with: 'Surname'
  fill_in 'email', with: 'Guest@mailer.com'
  fill_in 'password', with: 'test_password'
  fill_in 'password_confirmation', with: 'test_password'
  click_button 'Submit'
end

def log_out
  find(:xpath, "/html/body/nav/div/div/form/input").click
end
