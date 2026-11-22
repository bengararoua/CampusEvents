<?php
require 'config.php';

$method = $_SERVER['REQUEST_METHOD'];
$pdo = getPdo();

function eventFromRow(array $row): array
{
    return [
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

$columns = 'id, title, description, category, event_date, event_time, location, organizer, capacity, registered, image_url';

if ($method === 'GET') {
    $rows = $pdo->query("SELECT $columns FROM events ORDER BY event_date, id")->fetchAll();
    sendJson(array_map('eventFromRow', $rows));
}

if ($method === 'POST') {
    $body = readJsonBody();

    $title = trim($body['title'] ?? '');
    $description = trim($body['description'] ?? '');
    $category = trim($body['category'] ?? '');
    $date = trim($body['date'] ?? '');
    $time = trim($body['time'] ?? '09:00 AM');
    $location = trim($body['location'] ?? '');
    $organizer = trim($body['organizer'] ?? 'Campus Organizer');
    $capacity = (int) ($body['capacity'] ?? 0);
    $imageUrl = trim($body['imageUrl'] ?? 'assets/images/ui_ux_jam.jpg');

    if (mb_strlen($title) < 5) {
        sendJson(['error' => 'title must contain at least 5 characters'], 400);
    }
    if (mb_strlen($description) < 10) {
        sendJson(['error' => 'description must contain at least 10 characters'], 400);
    }
    if ($category === '' || $location === '') {
        sendJson(['error' => 'category and location are required'], 400);
    }
    $parsedDate = DateTime::createFromFormat('Y-m-d', $date);
    if (!$parsedDate || $parsedDate->format('Y-m-d') !== $date) {
        sendJson(['error' => 'date must use the format YYYY-MM-DD'], 400);
    }
    if ($capacity < 1 || $capacity > 5000) {
        sendJson(['error' => 'capacity must be between 1 and 5000'], 400);
    }

    $stmt = $pdo->prepare(
        'INSERT INTO events
            (title, description, category, event_date, event_time, location, organizer, capacity, registered, image_url)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, ?)'
    );
    $stmt->execute([
        $title, $description, $category, $date, $time,
        $location, $organizer, $capacity, $imageUrl,
    ]);

    $id = (int) $pdo->lastInsertId();
    $select = $pdo->prepare("SELECT $columns FROM events WHERE id = ?");
    $select->execute([$id]);
    sendJson(eventFromRow($select->fetch()), 201);
}

sendJson(['error' => 'Method not allowed'], 405);