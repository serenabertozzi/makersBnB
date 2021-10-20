feature 'WEBPAGE: Index' do
  
  scenario 'visiting the index page' do
    visit('/')
    expect(page).to have_content "Stay with us!"
  end

end