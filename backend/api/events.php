<?php
require 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    sendJson(['error' => 'Method not allowed'], 405);
}

$pdo = getPdo();
$rows = $pdo->query(
    'SELECT id, title, description, category, event_date, event_time, location, organizer, capacity, registered, image_url
     FROM events
     ORDER BY event_date, id'
)->fetchAll();

$events = [];
foreach ($rows as $row) {
    $events[] = [
        'id' => (int) $row['id'],
        'title' => $row['title'],
        'description' => $row['description'],
        'category' => $row['category'],
        'date' => $row['event_date'],
        'time' => $row['event_time'],
        'location' => $row['location'],
        'organizer' => $row['organizer'],
        'capacity' => (int) $row['capacity'],
        'registered' => (int) $row['registered'],
        'imageUrl' => $row['image_url'],
    ];
}

sendJson($events);
