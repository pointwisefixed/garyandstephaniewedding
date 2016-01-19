# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


steakEntree = Entree.create(:name => "The Steak", :description => 'New York Strip Steak, Sauteed Mushrooms and Cabernet Demi')
fishEntree = Entree.create(:name => 'The Fish', :description => 'Citrus Steamed Maryland Rockfish, Tarragon Hollandaise Sauce')
chickenEntree = Entree.create(:name => 'The Chicken', :description => 'Ratatouille Stuffed Breast of Chicken, Basil Tomato Cream')
veganEntree = Entree.create(:name => 'The Vegan', :description => 'Vegetarian / Vegan Option')


garyadmin = User.create(:username => 'gary.rosales', :email => 'gary@garyrosales.com', :password => 'ilsm2016!', :admin => true)
stephadmin = User.create(:username => 'stephanie.murguia', :email => 'stephanie.murguia@gmail.com', :password => 'ilgr2016!', :admin => true) 
