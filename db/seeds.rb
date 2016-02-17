# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# Note to self; to reset database and seed from scratch, use
#   rake db:reset db:seed

Category.create(name: 'TV Commedies')
Category.create(name: 'TV Dramas')
Category.create(name: 'Reality TV')
Category.create(name: 'Science Fiction')
Category.create(name: 'Animated')
Category.create(name: 'Satire')
Category.create(name: 'Detective')

futurama_description = "When Fry, a somewhat dim-witted 25 year-old pizza delivery boy for Panucci's Pizza is asked to make a drop at Applied Cryogenics, it's the beginning of a journey that will take him more than a thousand years into the future.\n\nFry falls into one of the company's capsules and doesn't emerge until the dawn of the year 3000. Here he befriends a beautiful one-eyed alien called Leela (a worker at the New York based cryogenics factory) and a degenerate robot named Bender. The trio track down Fry's great-great-great-etc. nephew, Professor Farnsworth, who hires the three to work for his intergalactic delivery service. Together they traverse the cosmos delivering goods for Planet Express, Leela serves as the ship's captain and Bender indulges in his love of booze, large cigars and pornography.\n\nIt was recently announced that Futurama will be returning with 26 new episodes in 2010 on Comedy Central. The cable net has already re-signed voice stars Billy West, Katey Sagal and John DiMaggio to reprise their animated roles."
futurama = Video.create(title: 'Futurama', description:futurama_description, category: Category.find_by_name('Animated'), video_url: "https://s3-eu-west-1.amazonaws.com/cf-myflix-development/videos/sample.mp4")
futurama.small_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "futurama.jpg")))
futurama.large_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "futurama_large.jpg")))
futurama.save

family_guy_description = "Family Guy is the hit animated sitcom schemed up by Seth MacFarlane (American Dad, The Cleveland Show and The Winner). The show was picked up by FOX and first aired in 1999, but soon after was put into the \"death timeslot\". Grasping for ratings from being up against Friends and Survivor, the show was cancelled in 2002.\n\nThe Family Guy DVD sets were released in mid 2003, and sales boomed. Along with this, and the high ratings from the reruns on Adult Swim, the show was re-picked up, and the new season aired on May 1st, 2005.\n\nThe show revolves around the Griffins, although mainly Peter, the fat, obnoxious, idiotic father who in the end will do anything for his family. Lois, his wife, does her best to keep things in check. Coming from a rich family (the Pewterschmidts), Lois can be elegant at certain times, and as wild as Peter at others. She's a stay-at-home mom who teaches piano in her spare time. Then there's Meg, their 16 year old daughter. Meg is socially awkward and often the bud of even her family's jokes. She'll do anything to be \"in with the in crowd\", but people have been known to set them selves on fire just to escape from looking at her. Chris, their 14 year old son, is somewhat mentally slow but artistically brilliant. Chris has no trouble making friends, but meeting girls is somewhat a problem for him. Stewie, the diabolically evil, super-intelligent, baby whose main focus is killing his mother Lois. And of course, Brian, the Griffin's martini sippin', dry witted, intelligent, talking dog who secretly loves Lois. Brian can enjoy a nice night at the opera with an intelligent woman, although some times his dog instincts get the best of him."
family_guy = Video.create(title: 'Family Guy', description:family_guy_description, category: Category.find_by_name('Animated'), video_url: "https://s3-eu-west-1.amazonaws.com/cf-myflix-development/videos/sample.mp4")
family_guy.small_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "family_guy.jpg")))
family_guy.large_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "family_guy_large.jpg")))
family_guy.save

south_park_description = "South Park is an award-winning animated series from creators Trey Parker and Matt Stone. They have invented a whole town full of colorful personalities, where a group of eight-year-old boys try to understand the world around them. Their parents, teachers, and town leaders all mean well, but the boys learn through their misadventures that even adults make mistakes, and even the youngest and slowest among us can be wise. Despite the serious issues tackled by the show, it is sharp, funny, and often brilliant.\n\nThe crude animation, first done with paper cut-outs and then computerized, is deceptively primitive. The visual roughness fits the coarse language of the characters, because this is definitely a show for mature audiences. South Park is one of those rare shows that can make you laugh, and make you think about your long-held beliefs, both at the same time."
south_park = Video.create(title: 'South Park', description:south_park_description, category:Category.find_by_name('Animated'), video_url: "https://s3-eu-west-1.amazonaws.com/cf-myflix-development/videos/sample.mp4")
south_park.small_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "south_park.jpg")))
south_park.large_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "south_park_large.jpg")))
south_park.save

monk_description = "Adrian Monk (Tony Shalhoub) was once a rising star with the San Francisco Police Department, legendary for using unconventional means to solve the department's most baffling cases. But after the tragic (and still unsolved) murder of his wife, the devastated Monk became obsessive-compulsive. His psychological disorder has caused him to develop an abnormal fear of virtually everything: germs, heights, crowds... even milk. Monk's condition eventually cost him his job, and continues to pose unique challenges in his everyday life.\n\nThose daily challenges eventually forced Monk to hire a personal nurse, Sharona Fleming (Bitty Schram), who was always there to offer her assistance when even the simplest of tasks (like organizing his sock drawer) became an angst-ridden ordeal for Monk. Along the way, Sharona also became Monk's own Girl Friday, an unlikely Dr. Watson to his Sherlock Holmes.\n\nWhen Sharona moved back to New Jersey with her son to re-marry her ex-husband, Monk once again became unable to function in his day-to-day life, let alone solve crimes. He slowly comes out of his funk when he meets Natalie Teeger (Traylor Howard), a single mom and bartender who enlists Monk's help when her home gets broken into twice within a week. Monk takes on her case only to find that the more time he spends with Natalie and her young daughter, the more he feels a connection with her - one that is reminiscent of his special relationship with Sharona. "
monk = Video.create(title: 'Monk', description:monk_description, category: Category.find_by_name('TV Dramas'), video_url: "https://s3-eu-west-1.amazonaws.com/cf-myflix-development/videos/sample.mp4")
monk.small_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "monk.jpg")))
monk.large_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "monk_large.jpg")))
monk.save

suits_description = "In Suits, one of Manhattan's top corporate lawyers (Gabriel Macht) sets out to recruit a new hotshot associate and hires the only guy that impresses him--a brilliant but unmotivated college dropout (Patrick J. Adams). Though he isn't actually a lawyer, this legal prodigy has the book smarts of a Harvard law grad and the street smarts of a hustler. However, in order to serve justice and save their jobs, both these unconventional thinkers must continue the charade. (Source: USA Network)"
suits = Video.create(title: 'Suits', description:suits_description, category:Category.find_by_name('TV Dramas'), video_url: "https://s3-eu-west-1.amazonaws.com/cf-myflix-development/videos/sample.mp4")
suits.small_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "suits.jpg")))
suits.large_cover.store!(File.new(File.join(Rails.root, "public", "tmp", "suits_large.jpg")))
suits.save

# User: koen
koen = User.create(name: "Koen Werdler", password: "password", email: "koen@werdler.com", admin: true)

Review.create(author: koen, video: suits, rating: 3, text: "Suits's first review. Woohoo!")
Review.create(author: koen, video: suits, rating: 5, text: "Suits is awesome!")
Review.create(author: koen, video: futurama, rating: 1, text: "It can be funny at times")

QueueItem.create(user: koen, video: suits)
QueueItem.create(user: koen, video: futurama)

# User: john
john = User.create(name: "John Edwards", password: "password", email: "john@example.com")

Review.create(author: john, video: south_park, rating: 5, text: "I love this show!")

QueueItem.create(user: john, video: south_park)

# User: grumpy
grumpy = User.create(name: "Grumpy Keen", password: "password", email: "grumpy@example.com")

Review.create(author: grumpy, video: south_park, rating: 1, text: "South Park is offensive, dirty and bad for everyone watching. I hate it. Do not watch.")

QueueItem.create(user: grumpy, video: south_park)
