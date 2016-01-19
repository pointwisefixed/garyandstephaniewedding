class CreateWeddingInfos < ActiveRecord::Migration
  def change
    create_table :wedding_infos do |t|
      t.text :hisInformation
      t.text :herInformation
      t.text :ourStory
      t.text :ourFirstMeeting
      t.text :ourFirstDate
      t.text :proposal
      t.text :theRing
      t.text :whenAndWhereIsTheWedding
      t.text :ceremony
      t.text :reception
      t.text :accomodations
      t.text :attending
      t.text :ourGallery
      t.text :dontMissIt
      t.text :moreEvents
      t.text :dancingParty
      t.text :flowerAndFlowers
      t.text :groomsmen
      t.text :bestFriend
      t.text :bridesmaid
      t.text :maidOfHonor
      t.text :bestMan
      t.text :bestBrideFriend
      t.text :giftRegistry
      t.text :rsvpInfo

      t.timestamps null: false
    end
  end
end
