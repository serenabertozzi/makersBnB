feature 'WEBPAGE: Visit sign up page' do

  scenario ':visiting sign up page' do
    visit('/')
    
    find(:xpath, "/html/body/nav/div/div/form[1]/input").click
    expect(current_path).to eq '/user'
    expect(page).to have_content "First Name"
    expect(page).to have_content "Email address"
    expect(page).to have_content "Password"
  end

end