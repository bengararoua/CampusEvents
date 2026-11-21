CREATE DATABASE IF NOT EXISTS campusevents
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE campusevents;

DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS registrations;
DROP TABLE IF EXISTS events;

CREATE TABLE events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description TEXT NOT NULL,
  category VARCHAR(50) NOT NULL,
  event_date DATE NOT NULL,
  event_time VARCHAR(20) NOT NULL,
  location VARCHAR(150) NOT NULL,
  organizer VARCHAR(100) NOT NULL,
  capacity INT NOT NULL,
  registered INT NOT NULL DEFAULT 0,
  image_url VARCHAR(255) NOT NULL
);

CREATE TABLE registrations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  event_id INT NOT NULL UNIQUE,
  status VARCHAR(30) NOT NULL DEFAULT 'Confirmed',
  registered_on VARCHAR(20) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

CREATE TABLE favorites (
  event_id INT PRIMARY KEY,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

INSERT INTO events
  (id, title, description, category, event_date, event_time, location, organizer, capacity, registered, image_url)
VALUES
  (1, 'Annual Campus AI Hackathon 2026', 'Hackathon universitaire sur l''intelligence artificielle.', 'Hackathons', '2026-12-15', '09:00 AM', 'ISET Bizerte', 'AI Student Club', 100, 72, 'assets/images/ai_hackathon.jpg'),
  (2, 'UI/UX Campus Design Jam 2026', 'Un sprint de design d''une journée pour repenser un service du campus.', 'Competitions', '2026-12-18', '10:00 AM', 'Design Center, Lab 3', 'Design Club', 120, 85, 'assets/images/ui_ux_jam.jpg'),
  (3, 'Robotics Club Showcase & Sumo Battle', 'Venez voir les robots étudiants s''affronter dans une arène de sumo.', 'Student Clubs', '2026-12-20', '02:00 PM', 'Mech Lab Arena', 'Robotics Club', 150, 110, 'assets/images/robotics_showcase.jpg'),
  (4, 'Global Climate & Sustainability Forum', 'Conférences et tables rondes sur l''action climatique sur le campus.', 'Conferences', '2026-12-22', '09:30 AM', 'Main Auditorium', 'Green Campus Initiative', 300, 190, 'assets/images/climate_forum.jpg'),
  (5, 'Flutter & Mobile Dev Bootcamp', 'Atelier pratique pour créer votre première application mobile avec Flutter.', 'Workshops', '2026-12-27', '09:00 AM', 'Turing Hall, Room 402', 'Mobile Dev Club', 60, 48, 'assets/images/flutter_bootcamp.jpg'),
  (6, 'Fintech & Blockchain Career Summit', 'Rencontrez des professionnels de la finance et des startups.', 'Conferences', '2026-12-29', '11:00 AM', 'Business School Aud. 2', 'Business Club', 200, 130, 'assets/images/fintech_summit.jpg'),
  (7, 'Autumn Acoustic Night', 'Une soirée de musique live en plein air par les groupes étudiants.', 'Cultural Events', '2027-01-05', '07:00 PM', 'Student Amphitheater', 'Music Club', 250, 140, 'assets/images/acoustic_night.jpg'),
  (8, 'Google Cloud Hands-on Workshop', 'Apprenez les bases du cloud computing et déployez votre première application.', 'Workshops', '2027-01-10', '10:00 AM', 'CS Lab 4, North Wing', 'Cloud Community', 80, 61, 'assets/images/google_cloud_workshop.jpg'),
  (9, 'Startup Pitch Competition', 'Présentez votre idée de startup devant un jury d''investisseurs.', 'Competitions', '2027-01-15', '02:00 PM', 'Innovation Hub', 'Entrepreneurship Club', 50, 37, 'assets/images/extra_5.jpg'),
  (10, 'Cybersecurity Awareness Conference', 'Conférence sur les bonnes pratiques en cybersécurité.', 'Conferences', '2027-01-20', '10:30 AM', 'Amphitheater B', 'Cyber Security Club', 180, 95, 'assets/images/extra_6.jpg'),
  (11, 'Cultural Food Festival', 'Découvrez les cuisines du monde préparées par les étudiants.', 'Cultural Events', '2027-01-25', '12:00 PM', 'Campus Green', 'International Students Office', 500, 320, 'assets/images/extra_10.jpg'),
  (12, 'Data Science Bootcamp', 'Introduction à la data science avec Python et Pandas.', 'Workshops', '2027-02-01', '09:00 AM', 'CS Lab 2', 'Data Science Club', 70, 52, 'assets/images/extra_11.jpg'),
  (13, 'IEEE Student Paper Contest', 'Compétition de présentation de papers scientifiques.', 'Competitions', '2027-02-05', '01:30 PM', 'Engineering Hall', 'IEEE Student Branch', 100, 44, 'assets/images/extra_12.jpg'),
  (14, 'Art & Tech Exhibition', 'Exposition d''œuvres d''art interactives mêlant technologie et créativité.', 'Cultural Events', '2027-02-10', '11:00 AM', 'Gallery 3', 'Arts & Culture Club', 200, 76, 'assets/images/extra_13.jpg'),
  (15, 'Career Fair 2027', 'Rencontrez des recruteurs et découvrez des offres de stage.', 'Conferences', '2027-02-15', '09:00 AM', 'Main Hall', 'Career Center', 1000, 610, 'assets/images/fintech_summit.jpg');
