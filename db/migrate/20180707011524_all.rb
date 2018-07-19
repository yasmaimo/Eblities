class All < ActiveRecord::Migration[5.1]
  def change
    create_table :social_profiles do |t|
			t.integer		:user_id,   		index: true
			t.string		:provider,   		null: false, index: true
			t.string		:uid,   				null: false, index: true
			t.string		:access_token
			t.string		:access_secret
			t.string		:name
			t.string		:nickname
			t.string		:email
			t.string		:url
			t.string		:image_url
			t.string		:description
			t.text			:other
			t.text			:credentials
			t.text			:raw_info
      t.timestamps
    end

    create_table :relationships do |t|
			t.integer		:follower_id,   index: true
			t.integer		:following_id,	index: true
      t.timestamps
    end
    add_index :relationships, [:follower_id, :following_id], unique: true

    create_table :articles do |t|
			t.integer		:user_id,   		index: true
			t.string		:title,   			index: true
			t.text			:body, 	  			index: true
      t.timestamps
    end

    create_table :comments do |t|
			t.integer		:article_id,  	index: true
			t.integer		:user_id, 			index: true
			t.string		:comment, 			index: true
      t.timestamps
    end

    create_table :images do |t|
			t.integer		:post_id,		  	index: true
			t.string		:post_type,			index: true
			t.string		:image, 				index: true
      t.timestamps
    end

    create_table :favorites do |t|
			t.integer		:article_id,  	index: true
			t.integer		:user_id, 			index: true
      t.timestamps
    end

    create_table :drafts do |t|
			t.integer		:user_id,   		index: true
			t.string		:title,   			index: true
			t.text			:body, 	  			index: true
      t.timestamps
    end

    create_table :keeps do |t|
			t.integer		:article_id,  	index: true
			t.integer		:user_id, 			index: true
      t.timestamps
    end

    create_table :contacts do |t|
			t.string		:title,			  	null: false, index: true
			t.string		:email,			  	null: false, index: true
			t.text			:contact,			 	null: false, index: true
			t.string		:status,			 	null: false, index: true
      t.timestamps
    end

    create_table :uploads do |t|
      t.string :image
      t.timestamps
    end

    create_table :posts do |t|
			t.integer		:user_id,   		index: true
			t.string		:post,   			index: true
      t.timestamps
    end

    create_table :notifications do |t|
      t.integer :user_id, index: true
      t.integer :notified_by_id,index: true
      t.integer :article_id,index: true
      t.string :notified_type
      t.boolean :read, default: false
      t.timestamps
    end

  end
end
