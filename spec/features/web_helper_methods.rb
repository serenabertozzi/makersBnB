
def host_login
  find(:xpath, "/html/body/nav/div/div/form[2]/input").click

  fill_in 'email', with: 'Host@mailer.com'
  fill_in 'password', with: 'test_password'
  click_button 'Submit'
end

def log_out
  find(:xpath, "/html/body/nav/div/div/form[2]/input").click
end

def make_bnb
  fill_in 'name', with: 'A nice house'
  fill_in 'location', with: 'Madrid'
  fill_in 'price', with: '150'
  click_button "Submit"
end

def host_sign_up
  # User.create(
  #   email: 'Host@mailer.com', 
  #   first_name: 'Host Martin', 
  #   last_name: 'Surname', 
  #   host: true, 
  #   password:'test_password', 
  #   password_confirmation:'test_password')

   find(:xpath, "/html/body/nav/div/div/form[1]/input").click
    fill_in 'first_name', with: 'Host Martin'
    fill_in 'last_name', with: 'Surname'
    fill_in 'email', with: 'Host@mailer.com'
    fill_in 'password', with: 'test_password'
    fill_in 'password_confirmation', with: 'test_password'
    find(:xpath, "//input[@value='true']").click
    click_button 'Submit'
end

def guest_sign_up

  # User.create(
  #   email: 'Guest@mailer.com', 
  #   first_name: 'Guest Jane', 
  #   last_name: 'Doe', 
  #   host: false, 
  #   password:'test_password', 
  #   password_confirmation:'test_password')

  find(:xpath, "/html/body/nav/div/div/form[1]/input").click
   
  fill_in 'first_name', with: 'Guest Jane'
  fill_in 'last_name', with: 'Doe'
  fill_in 'email', with: 'Guest@mailer.com'
  fill_in 'password', with: 'test_password'
  fill_in 'password_confirmation', with: 'test_password'
  find(:xpath, "//input[@value='false']").click
  click_button 'Submit'
end
