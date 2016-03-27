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

## Creating guests
guests = ['theresa.borgeson', 'sarah.gieseke', 'mikey.heard', 'lamiya.rahman', 'ruben.gomez','kristen.payne', 'romel.punsal', 'corey.wickliffe', 'alexandra.heinstein', 'felice.heinstein','robert.england', 'shannon.england', 'brijette.chenet', 'armando.arvizu', 'marilyn.murguia', 'jose.murguia','sheryl.abeyta', 'virginia.mcgrath', 'william.nicholson', 'deborah.murphy', 'matthew.nicholson', 'niamh.fennessy', 'john.nicholson', 'nancy.patterson', 'ryan.nicholson', 'shannon.olenick', 'robert.nicholson', 'gail.nicholson', 'derek.culhane', 'amanda.culhane', 'pauline.moody', 'joseph.nicholson', 'alisha.cutter', 'robert.nicholson.jr', 'rebecca.safier', 'robert.nicholson', 'silvia.murguia', 'erwin.rosales', 'ingrid.rosales', 'hector.rosales', 'joseph.dibisceglie', 'maria.dibisceglie', 'vincent.dibisceglie', 'jorge.jorquera', 'edith.jorquera', 'shanttel.jorquera', 'christopher.jorquera', 'andrew.jorquera', 'mostafa.balile', 'silvia.balile', 'salma.balile', 'jesus.chara.cervantes', 'denisse.zavala', 'miklos.pataky', 'sam.williams', 'paul.mcnally', 'abdul.majid', 'kevin.oriordan' ]

guests.each do |username| 
  User.create(:username => username, :password => 'alpaca')
end

