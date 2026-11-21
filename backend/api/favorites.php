<?php
require 'config.php';

$pdo = getPdo();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $ids = $pdo->query('SELECT event_id FROM favorites')->fetchAll(PDO::FETCH_COLUMN);
    sendJson(array_map('intval', $ids));
}

if ($method === 'POST') {
    $body = readJsonBody();
    $eventId = (int) ($body['eventId'] ?? 0);
    if ($eventId <= 0) {
        sendJson(['error' => 'eventId is required'], 400);
    }
    $stmt = $pdo->prepare('INSERT IGNORE INTO favorites (event_id) VALUES (?)');
    $stmt->execute([$eventId]);
    sendJson(['ok' => true], 201);
}

if ($method === 'DELETE') {
    $eventId = (int) ($_GET['eventId'] ?? 0);
    if ($eventId <= 0) {
        sendJson(['error' => 'eventId is required'], 400);
    }
    $stmt = $pdo->prepare('DELETE FROM favorites WHERE event_id = ?');
    $stmt->execute([$eventId]);
    sendJson(['ok' => true]);
}

sendJson(['error' => 'Method not allowed'], 405);
