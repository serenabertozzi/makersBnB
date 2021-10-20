feature 'WEBPAGE: Host Dashboard Actions' do

  before do
    visit('/')
    host_sign_up; log_out; host_login
  end
  
  scenario ':view dashboard' do
    find(:xpath, "/html/body/nav/div/div/form[1]/input").click
    expect(page).to have_content "Welcome Host Martin"
  end

  scenario ':add new bnb' do
    find(:xpath, "/html/body/nav/div/div/form[1]/input").click
    click_button "Add new bnb" 
    expect(page).to have_content "Create new listing"
     
    make_bnb
    expect(page).to have_content "Madrid"
    expect(page).to have_selector(:button, 'Delete')
    expect(page).to have_selector(:button, 'Edit')
  end

  scenario ':delete a bnb' do
    find(:xpath, "/html/body/nav/div/div/form[1]/input").click
    click_button "Add new bnb" 
    expect(page).to have_content "Create new listing"
     
    make_bnb
    click_button "Delete" 
    expect(page).to_not have_content "Madrid"
  end


end