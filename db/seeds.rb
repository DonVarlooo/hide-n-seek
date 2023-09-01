puts 'Destroy all'
UserGame.destroy_all
Game.destroy_all
User.destroy_all
puts 'Done'

addresses = [
  "1 Allée Adrienne-Lecouvreur ,Paris",
  "1 Allée Alexandre Vialatte ,Paris",
  "1 Allée Alquier Debrousse ,Paris",
  "1 Allée André-Breton ,Paris",
  "1 Allée Anne-de-Beaujeu ,Paris",
  "1 Allée Arthur-Honegger ,Paris",
  "1 Allée Blaise-Cendrars ,Paris",
  "1 Allée Célestin Hennion ,Paris",
  "1 Allée Christian Pineau ,Paris",
  "1 Allée d'Andrézieux ,Paris",
  "1 Allée Darius-Milhaud ,Paris",
  "1 Allée de Bercy ,Paris",
  "1 Allée de Fontainebleau ,Paris",
  "1 Allée de l'Espérance ,Paris",
  "1 Allée de la Comtesse-de-Ségur ,Paris",
  "1 Allée de la Deuxième-D.-B. ,Paris",
  "1 Allée de la Garance ,Paris",
  "1 Allée de la Reine-Marguerite ,Paris",
  "1 Allée de Longchamp ,Paris",
  "1 Allée de Madrid-à-Neuilly ,Paris",
  "1 Allée des Bouleaux ,Paris",
  "1 Allée des Buttes ,Paris",
  "1 Allée des Dames ,Paris",
  "1 Allée des Eiders ,Paris",
  "1 Allée des Érables ,Paris",
  "1 Allée des Fortifications ,Paris",
  "1 Allée des Frères-Voisin ,Paris",
  "1 Allée des Hortensias ,Paris",
  "1 Allée des Justes de France ,Paris",
  "1 Allée des Lapins ,Paris",
  "1 Allée des Poteaux ,Paris",
  "1 Allée des Quatre Carrefours ,Paris",
  "1 Allée des Refuzniks ,Paris",
  "1 Allée des Vergers ,Paris",
  "1 Allée Diane-de-Poitiers ,Paris",
  "1 Allée du Bord-de-l'Eau ,Paris",
  "1 Allée du Capitaine-Dronne ,Paris",
  "1 Allée du Chef-d'Escadron-de-Guillebon ,Paris",
  "1 Allée du Commandant Raynal ,Paris",
  "1 Allée du Général-Denain ,Paris",
  "1 Allée du Général-Koenig ,Paris",
  "1 Allée du Parc-de-Choisy ,Paris",
  "1 Allée du Père-Julien-Dhuit ,Paris",
  "1 Allée du Philosophe ,Paris",
  "1 Allée du Professeur Jean Bernard ,Paris",
  "1 Allée du Révérend Père Michel Riquet ,Paris",
  "1 Allée Eugène-Beaudouin ,Paris",
  "1 Allée Federico-Garcia-Lorca ,Paris",
  "1 Allée Fortunée ,Paris",
  "1 Allée Gabrielle-d'Estrées ,Paris",
  "1 Allée Gaston-Bachelard ,Paris",
  "1 Allée Georges-Besse ,Paris",
  "1 Allée Georges-Recipon ,Paris",
  "1 Allée Georges-Rouault ,Paris",
  "1 Allée Henry Dunant ,Paris",
  "1 Allée Jean Sablon ,Paris",
  "1 Allée Jean-Paulhan ,Paris",
  "1 Allée Jules-Supervielle ,Paris",
  "1 Allée Léon-Bourgeois ,Paris",
  "1 Allée Louis-Aragon ,Paris",
  "1 Allée Louise-Labé ,Paris",
  "1 Allée Marc-Chagall ,Paris",
  "1 Allée Marcel-Jambenoire ,Paris",
  "1 Allée Marcel-Proust ,Paris",
  "1 Allée Marguerite-Yourcenar ,Paris",
  "1 Allée Maria-Callas ,Paris",
  "1 Allée Marie-Laurent ,Paris",
  "1 Allée Marius-Barroux ,Paris",
  "1 Allée Maurice-Baumont ,Paris",
  "1 Allée Nijinski ,Paris",
  "1 Allée Paul-Deschanel ,Paris",
  "1 Allée Pernette-du-Guillet ,Paris",
  "1 Allée Pierre Mollaret ,Paris",
  "1 Allée Pierre-Lazareff ,Paris",
  "1 Allée Pilâtre-de-Rozier ,Paris",
  "1 Allée Rimski-Korsakov ,Paris",
  "1 Allée Rodenbach ,Paris",
  "1 Allée Royale ,Paris",
  "1 Allée Saint-Denis ,Paris",
  "1 Allée Saint-John-Perse ,Paris",
  "1 Allée Samuel Beckett ,Paris",
  "1 Allée Thomy-Thierry ,Paris",
  "1 Allée Valentin-Abeille ,Paris",
  "1 Allée Verhaeren ,Paris",
  "1 Allée Verte ,Paris",
  "1 Allée Vivaldi ,Paris",
  "1 Arcades des Champs-Élysées ,Paris"
]

User.create(name: 'Bapt', user_name: 'Babou', email: 'bapt@gmail.com', password: 'azerty')
User.create(name: 'Jer', user_name: 'Jerome', email: 'jerome@gmail.com', password: 'jerome')
User.create(name: 'Adrien', user_name: 'Adri', email: 'adrien@gmail.com', password: 'adrien')
User.create(name: 'Hugo', user_name: 'Mr Hide', email: 'hugo@gmail.com', password: 'azerty')

duration = [15, 20, 30, 45, 60, 85, 90, 120]
mode = ["1v1", "Multiplayer", "Royal Rumble", "Zombie"]

addresses.first(4).each do |address|
  cord = Geocoder.search(address).first&.coordinates
  next unless cord

  Game.create!(
    lat: cord[0],
    lng: cord[1],
    duration: duration.sample,
    name: "#{Faker::Name.first_name}War",
    mode: mode.sample,
    user: User.all.sample
  )
  puts "Nous venons de créer la partie numéro: #{Game.count}"
end
puts "seed completed, merci Thibault le boss de la log"
