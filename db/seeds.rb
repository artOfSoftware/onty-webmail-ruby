# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

message_statuses = MessageStatus.create([ 
	{ id: 0, name: 'Unread' },
	{        name: 'Read' }
	])

folders = Folder.create( [
	{ account_id:0, name: 'Inbox',    folder_type:1 },
	{ account_id:0, name: 'Sent',     folder_type:2 },
	{ account_id:0, name: 'Archived', folder_type:3 }
	] )

