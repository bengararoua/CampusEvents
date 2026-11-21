<?php
require 'config.php';

$pdo = getPdo();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $rows = $pdo->query(
        'SELECT event_id, status, registered_on FROM registrations ORDER BY id DESC'
    )->fetchAll();
    $registrations = [];
    foreach ($rows as $row) {
        $registrations[] = [
            'eventId' => (int) $row['event_id'],
            'status' => $row['status'],
            'registeredOn' => $row['registered_on'],
        ];
    }
    sendJson($registrations);
}

if ($method === 'POST') {
    $body = readJsonBody();
    $eventId = (int) ($body['eventId'] ?? 0);
    $status = $body['status'] ?? 'Confirmed';
    $registeredOn = $body['registeredOn'] ?? date('M j');
    if ($eventId <= 0) {
        sendJson(['error' => 'eventId is required'], 400);
    }
    $stmt = $pdo->prepare(
        'INSERT INTO registrations (event_id, status, registered_on)
         VALUES (?, ?, ?)
         ON DUPLICATE KEY UPDATE status = VALUES(status)'
    );
    $stmt->execute([$eventId, $status, $registeredOn]);
    sendJson(['ok' => true], 201);
}

if ($method === 'DELETE') {
    $eventId = (int) ($_GET['eventId'] ?? 0);
    if ($eventId <= 0) {
        sendJson(['error' => 'eventId is required'], 400);
    }
    $stmt = $pdo->prepare('DELETE FROM registrations WHERE event_id = ?');
    $stmt->execute([$eventId]);
    sendJson(['ok' => true]);
}

sendJson(['error' => 'Method not allowed'], 405);
